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

### Add grafana for monitoring

Install operators

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export namespace=yugabyte
  envsubst < ./yugabyte/tenant-monitoring-operator.yaml | oc --context ${context} apply -f - -n yugabyte
done
```

Install monitoring stack

Note this script tends to fail as helm does not handle well large charts. It's mostly safe to retry.

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export prometheus_password=$(oc --context ${context} extract secret/grafana-datasources -n openshift-monitoring --keys=prometheus.yaml --to=- | jq -r '.datasources[0].basicAuthPassword')
  envsubst < ./yugabyte/values.monitoring-stack.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade monitoring-stack ./charts/monitoring-stack -i -n yugabyte --create-namespace -f /tmp/values.yaml
  export grafana_token=$(oc --context ${context} sa get-token grafana-serviceaccount -n yugabyte)
  envsubst < ./yugabyte/grafana-datasource-prometheus.templ.yaml | oc --context ${context} apply -f - -n yugabyte
done
```

## Running the tpcc benchmark

### Workaround pkcs8 certificates

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} get secret yugabyte-tls-client-cert -n yugabyte -o jsonpath='{.data.tls\.key}' | base64 -d > /tmp/key.pem
  openssl pkcs8 -topk8 -inform PEM -in /tmp/key.pem -outform DER -out /tmp/key.pk8 -v1 PBE-MD5-DES -nocrypt
  export key=$(cat /tmp/key.pk8 | base64 -w 0)
  oc --context ${context} patch secret yugabyte-tls-client-cert -n yugabyte --patch "$(envsubst < ./yugabyte/cert-patch.yaml)" --type merge
done
```

### Create helper pod

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export namespace=yugabyte
  envsubst < ./yugabyte/helper-pod.yaml | oc --context ${context} apply -f - -n yugabyte
  oc --context ${context} start-build tpcc-runner-pom-build -n yugabyte
done
```

wait for the pod to come up

### Load data

```shell
export helper_pod=$(oc --context ${cluster1} get pod -n yugabyte | grep tpccbenchmark-helper-pod | awk '{print $1}')
oc --context ${cluster1} exec -n yugabyte ${helper_pod} -- ln -s /tmp/src/config ./config
oc --context ${cluster1} exec -n yugabyte ${helper_pod} -- java -Xmx8G -Dlog4j.configuration=/workload-config/log4j.properties -jar /deployments/oltpbench-1.0-jar-with-dependencies.jar --create=true --load=true --warehouses=1000 --loaderthreads 48 -c /workload-config/workload.xml
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

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall monitoring-stack -n yugabyte
done
```

### Cleanup

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} delete project yugabyte
done
```
