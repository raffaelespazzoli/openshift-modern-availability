# Kafka multicluster

## Deploy local storage operator

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} adm new-project openshift-local-storage
  export OC_VERSION=$(oc --context ${context} version -o yaml | grep openshiftVersion | grep -o '[0-9]*[.][0-9]*' | head -1)
  envsubst < ./local-storage-operator/operator.yaml | oc --context ${context} apply -f -
done
```

## Provision adequate nodes

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster_name=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  export ami=$(oc --context ${context} get machineset -n openshift-machine-api -o jsonpath='{.items[0].spec.template.spec.providerSpec.value.ami.id}')
  export machine_type=kafka
  export instance_type=d3.xlarge
  for z in a b c; do
    export zone=${region}${z}
    oc --context ${context} scale machineset -n openshift-machine-api $(envsubst < ./cockroachdb/machineset.yaml | yq -r .metadata.name) --replicas 0 
    envsubst < ./cockroachdb/machineset.yaml | oc --context ${context} apply -f -
  done
  oc --context ${context} apply -f ./local-storage-operator/local-storage.yaml
done
```

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
  export cluster=${context}
  envsubst < ./kafka/akhq-values.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade --install akhq akhq/akhq --create-namespace -n kafka -f /tmp/values.yaml
done
```

Enable monitoring

deploy the operator

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} apply -f ./kafka/user-workload-monitoring.yaml
  oc --context ${context} apply -f ./kafka/grafana/operator.yaml -n kafka
done
```

deploy grafana

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} apply -f ./kafka/grafana/grafana.yaml,./kafka/grafana/grafana-dashboard-kafka.yaml,./kafka/grafana/secret-grafana-k8s-proxy.yaml,./kafka/grafana/serving-cert-ca-bundle-cm.yaml,./kafka/grafana/configmap-trusted-ca-bundle.yaml -n kafka
  export BEARER_TOKEN=$(oc --context ${context} serviceaccounts get-token prometheus-user-workload -n openshift-user-workload-monitoring)
  envsubst < ./kafka/grafana/datasource.yaml | oc --context ${context} apply -f - -n kafka
done
```

## Run a performance test

https://gist.github.com/jkreps/c7ddb4041ef62a900e6c

create a topic

```shell
export tool_pod=$(oc --context cluster1 get pod -n kafka | grep tool | awk '{print $1}')
oc --context cluster1 exec -n kafka ${tool_pod} -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server kafka.kafka.svc.cluster.local:9093 --delete --topic test-topic --if-exists --command-config /config/admin-client.properties
oc --context cluster1 exec -n kafka ${tool_pod} -- /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server kafka.kafka.svc.cluster.local:9093 --create --topic test-topic --partitions 9 --replication-factor=3 --if-not-exists --command-config /config/admin-client.properties --config retention.ms=28800000 --config min.insync.replicas=2
```

### Single producer/consumer runs

start producer

```shell
export tool_pod=$(oc --context cluster1 get pod -n kafka | grep tool | awk '{print $1}')
oc --context cluster1 exec -n kafka ${tool_pod} -- /opt/bitnami/kafka/bin/kafka-producer-perf-test.sh --producer.config /config/producer.properties --topic test-topic --num-records 5000000 --print-metrics --throughput -1 --record-size 1024
```

start consumer

```shell
export tool_pod=$(oc --context cluster1 get pod -n kafka | grep tool | awk '{print $1}')
oc --context cluster1 exec -n kafka ${tool_pod} -- /opt/bitnami/kafka/bin/kafka-consumer-perf-test.sh --bootstrap-server kafka.kafka.svc.cluster.local:9093 --consumer.config /config/consumer.properties --topic test-topic --messages 5000000
```

### Multiple producer/consumer runs

```shell
export producer_number=1
export record_number=5000000
export record_size=1024
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} delete job kafka-producer -n kafka
  envsubst < ./kafka/producer-job.yaml | oc --context ${context} apply -f - -n kafka
done
```

## Troubleshoot

restart pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n kafka
done
```

rescale kafka pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} scale statefulset kafka --replicas 0 -n kafka
 oc --context ${context} scale statefulset kafka --replicas 3 -n kafka
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


Plan
run test with new config. 

additional optimization
noatime, largeio in mounting the volume

no sense in trying to push performance more.

Test consumer

Test producer and consumer together

Run and disaster 

Write the article.

