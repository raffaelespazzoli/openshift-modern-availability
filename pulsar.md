# Pulsar

## Helm installation

```shell
helm repo add apache https://pulsar.apache.org/charts
oc adm policy add-scc-to-user anyuid -z default -z pulsar-broker-acct -z pulsar-functions-worker -z pulsar-prometheus -n pulsar
oc apply -f ./pulsar/certs.yaml -n pulsar
helm upgrade pulsar apache/pulsar -i --create-namespace -n pulsar -f ./pulsar/values.yaml --set initialize=true
oc create route edge pulsar --service pulsar-pulsar-manager -n pulsar
oc create route edge grafana --service pulsar-grafana -n pulsar
oc create configmap manager-application-properties -f ./pulsar/application.properties -n pulsar
oc set volumes deployment pulsar-pulsar-manager --add --overwrite -t secret --secret-name pulsar-tls-manager --path /certs -n pulsar
oc set volumes deployment pulsar-pulsar-manager --add --overwrite -t configmap --configmap-name manager-application-properties --path /configuration -n pulsar
oc set env deployment pulsar-pulsar-manager SPRING_CONFIGURATION_FILE=/configuration/application.properties -n pulsar
```

### Uninstall

```shell
helm uninstall pulsar -n pulsar
oc delete pvc --all -n pulsar
```  

oc adm policy remove-scc-from-user nonroot -z default -z pulsar-broker-acct -z pulsar-functions-worker -z pulsar-prometheus -n pulsar
