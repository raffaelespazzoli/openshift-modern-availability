# NATS

## Deploy the operator

```shell
oc new-project nats-io
oc apply -f ./nats/prereqs.yaml -n nats-io
oc apply -f ./nats/operator.yaml -n nats-io
```

## Create NATS cluster

```shell
oc new-project nats-test
oc apply -f ./nats/nats-cluster.yaml -n nats-test
```

## Deploy via helm

```shell
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
oc apply -f ./nats/nats-certs.yaml -n nats-helm
helm upgrade nats nats/nats -i --create-namespace -n nats-helm -f ./nats/values.yaml
```

### Undeploy

```shell
helm uninstall nats -n nats-helm
```
