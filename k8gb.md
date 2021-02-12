# Deploy k8gb

## Prepare AWS STS Integration

Prepare OIDC endpoint

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} get -n openshift-kube-apiserver cm -o json bound-sa-token-signing-certs | jq -r '.data["service-account-001.pub"]' > /tmp/sa-signer-pkcs8.pub
  self-hosted-linux -key "/tmp/sa-signer-pkcs8.pub" | jq '.keys += [.keys[0]] | .keys[1].kid = ""' > "/tmp/keys.json"
  oc --context ${context} new-project oidc
  oc --context ${context} new-app rhel8/httpd-24 --name oidc -n oidc
  oc --context ${context} create route oidc -n oidc --service oidc
  export oidc_url=$(oc --context ${context} get route oidc -n oidc -o jsonpath='{.spec.host}')
  envsubst < ./k8gb/oidc.json > /tmp/discovery.json
  oc --context ${context} create configmap oidc -n oidc --from-file=/tmp/discovery --from-file=/tmp/keys.json
  oc --context ${context} set volumes dc/oidc -n oidc --add --overwrite true --configmap-name oidc --name oidc --path /var/www --type configmap
done
```

Federate AWS STS Service

```shell
export policy_arn=aws iam create-policy --policy-name AllowExternalDNSUpdates --policy-document file://./k8gb/aws-external-dns-policy.json | jq -r .Policy.Arn
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  export oidc_url=$(oc --context ${context} get route oidc -n oidc -o jsonpath='{.spec.host}')
  export thumbprint=$(openssl s_client -showcerts -servername  ${oidc_url} -connect ${oidc_url}:443 </dev/null 2>/dev/null | openssl x509 -outform PEM | openssl x509 -fingerprint -noout)
  export thumbprint="${thumbprint##*=}"
  export thumbprint="${thumbprint//:}"
  export oidc_arn=$(aws iam create-open-id-connect-provider --url ${oidc_url} --client-id-list sts.amazonaws.com --thumbprint-list ${thumbprint} | jq -r .OpenIDConnectProviderArn)
  envsubst < ./k8gb/aws-external-trust-role-policy.json > /tmp/trust-policy.json
  aws iam create-role --role-name external-dns-${cluster} --assume-role-policy-document file:///tmp/trust-policy.json
  aws iam attach-role-policy --role-name external-dns-${cluster} --policy-arn ${policy_arn}
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
  export cluster=${context} 
  export iam_role_arn=$(aws iam get-role --role-name external-dns-${cluster} | jq -r .Role.Arn)
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  export other_regions=$(echo ${csv_regions} | tr , '\n' | sort | uniq | grep -vx $(echo ${region} | tr , '\n' | sort | uniq) | paste -s -d,)
  envsubst < ./k8gb/values.tmpl.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade k8gb ./charts/k8gb -i -n k8gb --create-namespace -f /tmp/values.yaml
done
```

