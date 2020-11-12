# Install Yugabyte

## From the docs

```shell
helm repo add yugabytedb https://charts.yugabyte.com
helm repo update
for zone in a b c; do
  helm upgrade yb-demo-us-west-2${zone} yugabytedb/yugabyte -i -n yb-demo-us-west-2${zone} --create-namespace -f ./yugabyte/overrides${zone}.yaml
done
```

### uninstall

```shell
for zone in a b c; do
  helm uninstall yb-demo-us-west-2${zone} -n yb-demo-us-west-2${zone};
  oc delete pvc --all -n yb-demo-us-west-2${zone};
done
```

## Install - topology aware

```shell
oc apply -f ./yugabyte/issuer.yaml -n yugabyte
helm upgrade yugabyte ./charts/yugabyte -i -n yugabyte --create-namespace -f ./yugabyte/values.yaml
```

### Restart pods

```shell
oc rollout restart statefulset -n yugabyte
```

### Uninstall

```shell
helm uninstall yugabyte -n yugabyte
oc delete pvc --all -n yugabyte
```
