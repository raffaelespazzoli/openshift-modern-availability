# Deploy k8gb

## Prepare AWS STS Integration

Federate AWS STS Service

```shell
export policy_arn=$(aws iam create-policy --policy-name AllowExternalDNSUpdates --policy-document file://./k8gb/aws-external-dns-policy.json | jq -r .Policy.Arn)
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  export oidc_url=$(oc --context ${context} get authentication.config.openshift.io cluster -o jsonpath='{.spec.serviceAccountIssuer}')
  export oidc_hostname="${oidc_url#https://}" 
  export thumbprint=$(openssl s_client -showcerts -servername ${oidc_hostname} -connect ${oidc_hostname}:443 </dev/null 2>/dev/null | openssl x509 -outform PEM | openssl x509 -fingerprint -noout)
  export thumbprint="${thumbprint##*=}"
  export thumbprint="${thumbprint//:}"
  export oidc_arn=$(aws iam create-open-id-connect-provider --url ${oidc_url} --client-id-list sts.amazonaws.com --thumbprint-list ${thumbprint} | jq -r .OpenIDConnectProviderArn)
  envsubst < ./k8gb/aws-external-dns-trust-role-policy.json > /tmp/trust-policy.json
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
