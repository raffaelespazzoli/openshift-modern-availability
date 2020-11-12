# CockroachDB

In this step we are going to deploy a nine node cockroachdb cluster

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
    oc --context ${context} scale machineset -n openshift-machine-api $(envsubst < ./cockroachdb/machineset.yaml | yq -r .metadata.name) --replicas 0 
    envsubst < ./cockroachdb/machineset.yaml | oc --context ${context} apply -f -
    oc --context ${context} apply -f ./cockroachdb/storage-class.yaml
  done
done
```

### Deploy CRDB

this is a good source of info for fixing the crdb helm chart with regards to permissions to the cert files:
https://github.com/kubernetes/kubernetes/issues/34982

```shell
#helm repo add cockroachdb https://charts.cockroachdb.com/
#helm dependency update ./charts/vault-multicluster
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project cockroachdb
  export uid=$(oc --context ${context} get project cockroachdb -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.uid-range}'|sed 's/\/.*//')
  export guid=$(oc --context ${context} get project cockroachdb -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}'|sed 's/\/.*//')
  export cluster=${context}
  export region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
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

### Deploy the enterprise license

```shell
source ./cockroachdb/license.sh
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='SET CLUSTER SETTING cluster.organization = '\""${cluster_organization}"\"';'
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='SET CLUSTER SETTING enterprise.license = '\""${enterprise_license}"\"';'
```

### Insert region locations

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="UPSERT into system.locations VALUES ('region', 'us-east-1', 37.478397, -76.453077); UPSERT into system.locations VALUES ('region', 'us-east-2', 40.417287, -76.453077); UPSERT into system.locations VALUES ('region', 'us-west-1', 38.837522, -120.895824); UPSERT into system.locations VALUES ('region', 'us-west-2', 43.804133, -120.554201); UPSERT into system.locations VALUES ('region', 'ca-central-1', 56.130366, -106.346771); UPSERT into system.locations VALUES ('region', 'eu-central-1', 50.110922, 8.682127); UPSERT into system.locations VALUES ('region', 'eu-west-1', 53.142367, -7.692054); UPSERT into system.locations VALUES ('region', 'eu-west-2', 51.507351, -0.127758); UPSERT into system.locations VALUES ('region', 'eu-west-3', 48.856614, 2.352222); UPSERT into system.locations VALUES ('region', 'ap-northeast-1', 35.689487, 139.691706); UPSERT into system.locations VALUES ('region', 'ap-northeast-2', 37.566535, 126.977969); UPSERT into system.locations VALUES ('region', 'ap-northeast-3', 34.693738, 135.502165); UPSERT into system.locations VALUES ('region', 'ap-southeast-1', 1.352083, 103.819836); UPSERT into system.locations VALUES ('region', 'ap-southeast-2', -33.86882, 151.209296); UPSERT into system.locations VALUES ('region', 'ap-south-1', 19.075984, 72.877656); UPSERT into system.locations VALUES ('region', 'sa-east-1', -23.55052, -46.633309);"
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SELECT * FROM system.locations;"


oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="UPSERT into system.locations VALUES ('zone', 'us-east-1', 37.478397, -76.453077); UPSERT into system.locations VALUES ('zone', 'us-east-2', 40.417287, -76.453077); UPSERT into system.locations VALUES ('zone', 'us-west-1', 38.837522, -120.895824); UPSERT into system.locations VALUES ('zone', 'us-west-2', 43.804133, -120.554201); UPSERT into system.locations VALUES ('zone', 'ca-central-1', 56.130366, -106.346771); UPSERT into system.locations VALUES ('zone', 'eu-central-1', 50.110922, 8.682127); UPSERT into system.locations VALUES ('zone', 'eu-west-1', 53.142367, -7.692054); UPSERT into system.locations VALUES ('zone', 'eu-west-2', 51.507351, -0.127758); UPSERT into system.locations VALUES ('zone', 'eu-west-3', 48.856614, 2.352222); UPSERT into system.locations VALUES ('zone', 'ap-northeast-1', 35.689487, 139.691706); UPSERT into system.locations VALUES ('zone', 'ap-northeast-2', 37.566535, 126.977969); UPSERT into system.locations VALUES ('zone', 'ap-northeast-3', 34.693738, 135.502165); UPSERT into system.locations VALUES ('zone', 'ap-southeast-1', 1.352083, 103.819836); UPSERT into system.locations VALUES ('zone', 'ap-southeast-2', -33.86882, 151.209296); UPSERT into system.locations VALUES ('zone', 'ap-south-1', 19.075984, 72.877656); UPSERT into system.locations VALUES ('zone', 'sa-east-1', -23.55052, -46.633309);"
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SELECT * FROM system.locations;"
```

## Run the TPCC load test

https://github.com/jhatcher9999/tpcc-distributed-k8s

### Initialize warehouses

refer also to this: https://github.com/jhatcher9999/tpcc-distributed-k8s

```shell
oc --context ${cluster1} run tpcc-loader -n cockroachdb -ti --image=mgoddard/crdb-workload:1.0 --restart='Never' -- /cockroach/workload init tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --warehouses 1000 --partition-affinity=0 --partitions=3 --partition-strategy=leases --drop --zones=us-east-1,us-east-2,us-west-2 --deprecated-fk-indexes
```

This can take about three hours to complete.

### Run tests

open three terminals, try to start the following commands at the same time

in terminal one run

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster1 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 1000 --ramp=180s --partition-affinity=0 --partitions=3 --partition-strategy=leases --split --scatter --tolerate-errors | tee ./cluster1.log
```

in terminal two run:

```shell
export tools_pod=$(oc --context cluster2 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster2 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 1000 --ramp=180s --partition-affinity=1 --partitions=3 --partition-strategy=leases --split --scatter --tolerate-errors | tee ./cluster2.log
```
  
in terminal three run

```shell
export tools_pod=$(oc --context cluster3 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster3 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 1000 --ramp=180s --partition-affinity=2 --partitions=3 --partition-strategy=leases --split --scatter --tolerate-errors | tee ./cluster3.log
```

<!--
## Run the ycsb test

load the data

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload init ycsb  --drop postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require
```

--splits=50

Run the test

in terminal one run

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster1 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run ycsb --ramp=3m --duration=20m  --tolerate-errors postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require  | tee ./yscb_cluster1.log
```

--concurrency=3 --max-rate=1000

in terminal two run:

```shell
export tools_pod=$(oc --context cluster2 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster2 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run ycsb --ramp=3m --duration=20m  --tolerate-errors postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require  | tee ./yscb_cluster2.log
```
  
in terminal three run

```shell
export tools_pod=$(oc --context cluster3 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster3 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run ycsb --ramp=3m --duration=20m  --tolerate-errors postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require  | tee ./yscb_cluster3.log
```
-->
## Run the disaster recovery test

Run the tpcc test as described above.
Isolate the us-west-1 VPC and observe the results.

```shell
export cluster=cluster3
export region=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
export instance_id=$(oc --context ${cluster} get machine -n openshift-machine-api -o json | jq -rc '[ .items[] | select(.status.phase == "Running")] | .[0].status.providerStatus.instanceId')
export vpc_id=$(aws --region ${region} ec2 describe-instances --instance-ids=${instance_id} | jq -r .Reservations[0].Instances[0].VpcId )
export network_acl_id=$(aws --region ${region} ec2 describe-network-acls --filters Name=vpc-id,Values=${vpc_id} | jq -r .NetworkAcls[0].NetworkAclId)
aws --region ${region} ec2 replace-network-acl-entry --egress --network-acl-id=${network_acl_id} --protocol=-1 --rule-action=DENY --rule-number=100 --cidr-block=0.0.0.0/0
aws --region ${region} ec2 replace-network-acl-entry --ingress --network-acl-id=${network_acl_id} --protocol=-1 --rule-action=DENY --rule-number=100 --cidr-block=0.0.0.0/0
```

To restore traffic, run the following:

```shell
aws --region ${region} ec2 replace-network-acl-entry --egress --network-acl-id=${network_acl_id} --protocol=-1 --rule-action=ALLOW --rule-number=100 --cidr-block=0.0.0.0/0
aws --region ${region} ec2 replace-network-acl-entry --ingress --network-acl-id=${network_acl_id} --protocol=-1 --rule-action=ALLOW --rule-number=100 --cidr-block=0.0.0.0/0
```

## Troubleshooting CRDB

In case of issues, this command can be used to drop the database

```shell
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='DROP DATABASE tpcc;'
```

In case of issues, this command can be used to collect the logs

```shell
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach debug zip  /tmp/log.zip --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} rsync -c tools -n cockroachdb ${tools_pod}:/tmp/log.zip ./
```

Restart the cockroachdb pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n cockroachdb
done
```

Scale to 0 and back (fixes certificate expired issue)

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} scale statefulset cockroachdb -n cockroachdb --replicas=0
 oc --context ${context} scale statefulset cockroachdb -n cockroachdb --replicas=3
done
```

## clean-up

delete crdb

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall cockroachdb -n cockroachdb 
  oc --context ${context} delete pvc datadir-cockroachdb-0 datadir-cockroachdb-1 datadir-cockroachdb-2 -n cockroachdb
done
```
