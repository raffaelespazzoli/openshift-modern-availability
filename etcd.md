
# etcd

## Deploy etcd multicluster

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  envsubst < ./etcd/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade etcd ./charts/etcd-multicluster -i --create-namespace -n etcd -f /tmp/values.yaml
done
```

## Deploy coredns

```shell
helm repo add coredns https://coredns.github.io/helm
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  envsubst < ./etcd/coredns-values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade coredns coredns/coredns -i --create-namespace -n etcd -f /tmp/values.yaml
done
```

### Test coredns

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export reversed_global_base_domain=$(echo ${global_base_domain} | tr '.' $'\n' | tac | paste -s -d '.')
export reversed_global_base_domain_path=$(echo ${reversed_global_base_domain} | tr . /)
oc --context cluster1 exec -n etcd etcd-0 -- etcdctl --endpoints https://etcd.etcd.svc.clusterset.local:2379 --cacert /certs/ca.crt --key /certs/tls.key --cert /certs/tls.crt put /glb/${reversed_global_base_domain_path}/etcd '{"host":"1.1.1.1","ttl":60}'
oc --context cluster1 exec -n etcd etcd-0 -- etcdctl --endpoints https://etcd.etcd.svc.clusterset.local:2379 --cacert /certs/ca.crt --key /certs/tls.key --cert /certs/tls.crt get /glb/${reversed_global_base_domain_path}/etcd
export name_resolver_ip=$(oc --context cluster1 get svc coredns-coredns -n etcd -o jsonpath='{.spec.clusterIP}')
export dns_pod=$(oc --context cluster1 get pods -n openshift-dns --no-headers -o jsonpath='{.items[0].metadata.name}')
oc --context cluster1 exec -n openshift-dns -c dns ${dns_pod} -- nslookup -port=5353 etcd.${global_base_domain} ${name_resolver_ip}
```

more complex example with clusters and group
we create the following

cluster1 ip1 myservice.<global_comain>
cluster1 ip2 myservice.<global_comain>
cluster2 ip1 myservice.<global_comain>
cluster2 ip2 myservice.<global_comain>

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export reversed_global_base_domain=$(echo ${global_base_domain} | tr '.' $'\n' | tac | paste -s -d '.')
export reversed_global_base_domain_path=$(echo ${reversed_global_base_domain} | tr . /)
oc --context cluster1 exec -n etcd etcd-0 -- etcdctl --endpoints https://etcd.etcd.svc.clusterset.local:2379 --cacert /certs/ca.crt --key /certs/tls.key --cert /certs/tls.crt put /glb/${reversed_global_base_domain_path}/myservice/cluster1/1 '{"host":"1.1.1.1","ttl":60, "group":"myservice"}'
oc --context cluster1 exec -n etcd etcd-0 -- etcdctl --endpoints https://etcd.etcd.svc.clusterset.local:2379 --cacert /certs/ca.crt --key /certs/tls.key --cert /certs/tls.crt put /glb/${reversed_global_base_domain_path}/myservice/cluster1/2 '{"host":"1.1.1.2","ttl":60, "group":"myservice"}'
oc --context cluster1 exec -n etcd etcd-0 -- etcdctl --endpoints https://etcd.etcd.svc.clusterset.local:2379 --cacert /certs/ca.crt --key /certs/tls.key --cert /certs/tls.crt put /glb/${reversed_global_base_domain_path}/myservice/cluster2/1 '{"host":"1.1.1.3","ttl":60, "group":"myservice"}'
oc --context cluster1 exec -n etcd etcd-0 -- etcdctl --endpoints https://etcd.etcd.svc.clusterset.local:2379 --cacert /certs/ca.crt --key /certs/tls.key --cert /certs/tls.crt put /glb/${reversed_global_base_domain_path}/myservice/cluster2/2 '{"host":"1.1.1.4","ttl":60, "group":"myservice"}'
export name_resolver_ip=$(oc --context cluster1 get svc coredns-coredns -n etcd -o jsonpath='{.spec.clusterIP}')
export dns_pod=$(oc --context cluster1 get pods -n openshift-dns --no-headers -o jsonpath='{.items[0].metadata.name}')
oc --context cluster1 exec -n openshift-dns -c dns ${dns_pod} -- nslookup -port=5353 myservice.${global_base_domain} ${name_resolver_ip}
export dns_pod2=$(oc --context cluster2 get pods -n openshift-dns --no-headers -o jsonpath='{.items[0].metadata.name}')
oc --context cluster2 exec -n openshift-dns -c dns ${dns_pod2} -- nslookup -port=5353 myservice.${global_base_domain} ${name_resolver_ip}
```

## Troubleshoot

restart pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n etcd
done
```

rescale kafka pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} scale statefulset etcd --replicas 0 -n etcd
 oc --context ${context} scale statefulset etcd --replicas 3 -n etcd
done
```

## clean-up

delete etcd

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall etcd -n etcd 
  oc --context ${context} delete pvc --all -n etcd
done
```

delete coredns

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall coredns -n etcd 
done
```
