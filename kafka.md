# Kafka multicluster

## Deploy Kafka multicluster

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  envsubst < ./kafka/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade kafka ./charts/kafka-multicluster -i --create-namespace -n kafka -f /tmp/values.yaml
done
```

deploy the ui

```shell
helm repo add akhq https://akhq.io/
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} apply -f ./kafka/akhq-certificate.yaml -n kafka
  envsubst < ./kafka/akhq-route.yaml | oc --context ${context} apply -f - -n kafka
  helm --kube-context ${context} upgrade --install akhq akhq/akhq --create-namespace -n kafka -f ./kafka/akhq-values.yaml
done
```

## Troubleshoot

restart pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n kafka
done
```

rescale zookeeper pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} scale statefulset zookeeper --replicas 0 -n kafka
 oc --context ${context} scale statefulset zookeeper --replicas 2 -n kafka
done
```

## clean-up

delete kafka

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall kafka -n kafka 
  oc --context ${context} delete pvc --all -n kafka
done
```
