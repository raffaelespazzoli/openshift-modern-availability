# Deploy k8gb

## Prepare AWS STS Integration

Create OID discovery endpoints and aws sts federation

```shell
export policy_arn=$(aws iam create-policy --policy-name AllowExternalDNSUpdates --policy-document file://./k8gb/aws-external-dns-policy.json | jq -r .Policy.Arn)
for context in ${cluster1} ${cluster2} ${cluster3}; do
  # OIDC discovery endpoint
  oc --context ${context} get -n openshift-kube-apiserver cm -o json bound-sa-token-signing-certs | jq -r '.data["service-account-001.pub"]' > /tmp/sa-signer-pkcs8.pub
  ./k8gb/bin/self-hosted-linux -key "/tmp/sa-signer-pkcs8.pub" | jq '.keys += [.keys[0]] | .keys[1].kid = ""' > "/tmp/keys.json"
  export cluster_name=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  if [ ${region} == "us-east-1" ]; then 
    export http_location=$(aws s3api create-bucket --bucket oidc-discovery-${cluster_name} --region ${region} | jq -r .Location | sed 's:/*$::')
    export http_location=http:/${http_location}.s3.amazonaws.com
  else
    export http_location=$(aws s3api create-bucket --bucket oidc-discovery-${cluster_name} --region ${region} --create-bucket-configuration LocationConstraint=${region} | jq -r .Location | sed 's:/*$::')
  fi
  export oidc_hostname="${http_location#http://}" 
  export oidc_url=https://${oidc_hostname}
  envsubst < ./k8gb/oidc.json > /tmp/discovery.json
  aws s3api put-object --bucket oidc-discovery-${cluster_name} --key keys.json --body /tmp/keys.json
  aws s3api put-object --bucket oidc-discovery-${cluster_name} --key '.well-known/openid-configuration' --body /tmp/discovery.json
  aws s3api put-object-acl --bucket oidc-discovery-${cluster_name} --key keys.json --acl public-read
  aws s3api put-object-acl --bucket oidc-discovery-${cluster_name} --key '.well-known/openid-configuration' --acl public-read
  oc --context ${context} patch authentication.config.openshift.io cluster --type "json" -p="[{\"op\": \"replace\", \"path\": \"/spec/serviceAccountIssuer\", \"value\":\"${oidc_url}\"}]"

  # AWS STS federation
  export thumbprint=$(openssl s_client -showcerts -servername ${oidc_hostname} -connect ${oidc_hostname}:443 </dev/null 2>/dev/null | openssl x509 -outform PEM | openssl x509 -fingerprint -noout)
  export thumbprint="${thumbprint##*=}"
  export thumbprint="${thumbprint//:}"
  export oidc_arn=$(aws iam create-open-id-connect-provider --url ${oidc_url} --client-id-list sts.amazonaws.com --thumbprint-list ${thumbprint} | jq -r .OpenIDConnectProviderArn)
  envsubst < ./k8gb/aws-external-dns-trust-role-policy.json > /tmp/trust-policy.json
  aws iam create-role --role-name external-dns-${cluster_name} --assume-role-policy-document file:///tmp/trust-policy.json
  aws iam attach-role-policy --role-name external-dns-${cluster_name} --policy-arn ${policy_arn}
done
```

Deploy k8gb

```shell
helm repo add k8gb https://www.k8gb.io
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export cluster_zone_id=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.publicZone.id}')
export base_domain=${cluster_base_domain#*.}
export global_base_domain=k8gb.${base_domain}
export csv_regions=us-east-1,us-east-2,us-west-2
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project k8gb
  export cluster=${context} 
  export cluster_name=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  export iam_role_arn=$(aws iam get-role --role-name external-dns-${cluster_name} | jq -r .Role.Arn)
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  export other_regions=$(echo ${csv_regions} | tr , '\n' | sort | uniq | grep -vx $(echo ${region} | tr , '\n' | sort | uniq) | paste -s -d,)
  export uid=$(oc --context ${context} get project k8gb -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.uid-range}'|sed 's/\/.*//')
  export guid=$(oc --context ${context} get project k8gb -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}'|sed 's/\/.*//')
  envsubst < ./k8gb/values.tmpl.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade k8gb k8gb/k8gb -i -n k8gb --create-namespace -f /tmp/values.yaml
  oc --context ${context} adm policy add-role-to-user allow-nonroot-scc -z k8gb -n k8gb
  oc --context ${context} adm policy add-cluster-role-to-user system:openshift:openshift-controller-manager:ingress-to-route-controller -z k8gb -n k8gb
done
```

## test

```shell
helm repo add podinfo https://stefanprodan.github.io/podinfo
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project k8gb-test
  helm --kube-context ${context} upgrade --install frontend --namespace k8gb-test --create-namespace -f ./k8gb/test-app/values.yaml --set ui.message="${context}" podinfo/podinfo
  oc --context ${context} apply -f ./k8gb/test-app/unhealthy-app.yaml -n k8gb-test
  oc --context ${context} apply -f ./k8gb/test-app/test-k8gb.yaml -n k8gb-test
done
```

## Uninstall

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall k8gb -n k8gb 
done
```
