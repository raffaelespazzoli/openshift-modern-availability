# Pulsar

## Helm installation

```shell
helm repo add apache https://pulsar.apache.org/charts
oc new-project pulsar
oc adm policy add-scc-to-user anyuid -z default -z pulsar-broker-acct -z pulsar-functions-worker -z pulsar-prometheus -z pulsar-bookie -z pulsar-zookeeper -z pulsar-proxy -n pulsar
#oc apply -f ./pulsar/certs.yaml -n pulsar
helm upgrade pulsar apache/pulsar -i --create-namespace -n pulsar -f ./pulsar/values.yaml --set initialize=true
oc create route edge pulsar --service pulsar-pulsar-manager -n pulsar
oc create route edge grafana --service pulsar-grafana -n pulsar
account:pulsar/pulsar
```

### Restart all pods

```shell
oc rollout restart statefulset -n pulsar
oc rollout restart deployment -n pulsar
```

### Uninstall

```shell
helm uninstall pulsar -n pulsar
oc delete pvc --all -n pulsar
```  
