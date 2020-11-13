# Install Yugabyte

## Create adequate nodes

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster_name=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  export ami=$(oc --context ${context} get machineset -n openshift-machine-api -o jsonpath='{.items[0].spec.template.spec.providerSpec.value.ami.id}')
  export machine_type=yugabyte
  export instance_type=c5d.4xlarge
  for z in a b c; do
    export zone=${region}${z}
    oc --context ${context} scale machineset -n openshift-machine-api $(envsubst < ./yugabyte/machineset.yaml | yq -r .metadata.name) --replicas 0 
    envsubst < ./yugabyte/machineset.yaml | oc --context ${context} apply -f -
  done
  oc --context ${context} apply -f ./yugabyte/storage-class.yaml
done
```

## Deploy yugabyte DB

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project yugabyte
  export cluster=${context}
  export uid=$(oc --context ${context} get project yugabyte -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.uid-range}'|sed 's/\/.*//')
  export guid=$(oc --context ${context} get project yugabyte -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}'|sed 's/\/.*//')  
  envsubst < ./yugabyte/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade yugabyte ./charts/yugabyte -i -n yugabyte --create-namespace -f /tmp/values.yaml
done
```

## Trouleshooting

### Restart pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} rollout restart statefulset -n yugabyte
done
```

### Uninstall yugabyte

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall yugabyte -n yugabyte
  oc --context ${context} delete pvc --all -n yugabyte
done
```
