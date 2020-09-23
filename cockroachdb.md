# CockroachDB

In this step we are going to deploy cockroachdb

## Deploy cockroachDB

### Create adequate nodes

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster_name=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  export ami=$(oc --context ${context} get machineset -n openshift-machine-api -o jsonpath='{.items[0].spec.template.spec.providerSpec.value.ami.id}')
  export machine_type=cockroach
  export instance_type=c5d.4xlarge
  for z in a b c; do
    export zone=${region}${z}
    envsubst < ./cockroachdb/machineset.yaml | oc --context ${context} apply -f -
  done
done
```

### Deploy CRDB

this is a good source of info for fixing the crdb helm chart with regards to permissions to the cert files:
https://github.com/kubernetes/kubernetes/issues/34982


```shell
helm repo add cockroachdb https://charts.cockroachdb.com/
helm dependency update ./charts/vault-multicluster
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project cockroachdb
  export uid=$(oc --context ${context} get project cockroachdb -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.uid-range}'|sed 's/\/.*//')
  export guid=$(oc --context ${context} get project cockroachdb -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}'|sed 's/\/.*//')
  export cluster=${context}
  envsubst < ./cockroachdb/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade cockroachdb ./charts/cockroachdb-multicluster -i --create-namespace -n cockroachdb -f /tmp/values.yaml
done
```

### Start and Verify the cluster (run once only)

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach init --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach node status --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
```

### Create CRDB admin user

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='CREATE USER dba WITH PASSWORD dba;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='GRANT admin TO dba WITH ADMIN OPTION;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
```

### Connecting to the CRDB ui

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
echo cockroachdb.${global_base_domain}
```

connect to that url user dba/dba

At this point your architecture should look like the below image:

![CRDB](./media/CRDB.png)

## Run the TPCC load test

https://github.com/jhatcher9999/tpcc-distributed-k8s

### Deploy the enterprise license

```shell
source ./cockroachdb/license.sh
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='SET CLUSTER SETTING cluster.organization = '\""${cluster_organization}"\"';'
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='SET CLUSTER SETTING enterprise.license = '\""${enterprise_license}"\"';'
```

### Initialize warehouses

```shell
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload init tpcc postgresql://dba:admin@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --warehouses 1000 --partition-affinity=0 --partitions=3 --partition-strategy=leases --zones=cluster1,cluster2,cluster3
```

In case of issues, this command can be used to drop the database

```shell
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='DROP DATABASE tpcc;'
```

```shell
oc --context ${cluster2} exec $tools_pod2 -c tools -n cockroachdb -- /cockroach/cockroach debug zip  /cockroach/cockroach-certs/log.zip --certs-dir=/crdb-certs --host cockroachdb-0.cluster2.cockroachdb.cockroachdb.svc.clusterset.local
```

### Run tests

open three terminals, try to start the following commands at the same time

in terminal one run

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster1 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:admin@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 1000 --ramp=180s --partition-affinity=0 --partitions=3 --partition-strategy=leases
```

in terminal two run:

```shell
export tools_pod=$(oc --context cluster2 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster2 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:admin@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 1000 --ramp=180s --partition-affinity=1 --partitions=3 --partition-strategy=leases
```
  
in terminal three run

```shell
export tools_pod=$(oc --context cluster3 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster3 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:admin@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 1000 --ramp=180s --partition-affinity=2 --partitions=3 --partition-strategy=leases
```
  
  
'postgresql://root@cockroachdb-public:26257?sslmode=verify-full&sslcert=/cockroach-certs/client.root.crt&sslkey=/cockroach-certs/client.root.key&sslrootcert=/cockroach-certs/ca.crt'

'postgresql://root@cockroachdb-public:26257?sslmode=verify-full&sslcert=/cockroach-certs/client.root.crt&sslkey=/cockroach-certs/client.root.key&sslrootcert=/cockroach-certs/ca.crt'

## clean-up

delete crds

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall cockroachdb -n cockroachdb 
  oc --context ${context} delete pvc datadir-cockroachdb-0 datadir-cockroachdb-1 datadir-cockroachdb-2 -n cockroachdb
done
```


SET CLUSTER SETTING cluster.organization = 'Acme Company';
SET CLUSTER SETTING enterprise.license = 'crl-0-ChBkwDqH6TJL8pgttSTmBbKpEJ/brPwFGAE';
