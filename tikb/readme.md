tikb test

```shell
helm repo add pingcap https://charts.pingcap.org/
kubectl apply -f https://raw.githubusercontent.com/pingcap/tidb-operator/v1.2.4/manifests/crd.yaml
helm upgrade tidb-operator pingcap/tidb-operator -n tidb-operator --create-namespace -i --set scheduler.create="false"
helm upgrade tidb-cluster pingcap/tidb-cluster -n tidb-cluster --create-namespace -i 
```
