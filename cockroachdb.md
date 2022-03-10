# CockroachDB

In this step we are going to deploy a nine node cockroachdb cluster

## Deploy cockroachDB

### Create adequate nodes

```shell
export infrastructure=$(oc get infrastructure cluster -o jsonpath='{.spec.platformSpec.type}'| tr '[:upper:]' '[:lower:]')
for cluster in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${control_cluster} uninstall cockroach-machine-pool -n ${cluster}
  envsubst < ./cockroachdb/machinepool-values.templ.yaml > /tmp/values.yaml 
  helm --kube-context ${control_cluster} upgrade cockroach-machine-pool ./charts/machine-pool -n ${cluster} --atomic -i -f /tmp/values.yaml
done
```

### Deploy CRDB

this is a good source of info for fixing the crdb helm chart with regards to permissions to the cert files:
https://github.com/kubernetes/kubernetes/issues/34982

```shell
export infrastructure=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.spec.platformSpec.type}'| tr '[:upper:]' '[:lower:]')
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

### Deploy the enterprise license

```shell
source ./cockroachdb/license.sh
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='SET CLUSTER SETTING cluster.organization = '\""${cluster_organization}"\"';'
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute='SET CLUSTER SETTING enterprise.license = '\""${enterprise_license}"\"';'
```

### insert region locations -- aws

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="\
UPSERT into system.locations VALUES ('region', 'us-east-1', 37.478397, -76.453077); \
UPSERT into system.locations VALUES ('region', 'us-east-2', 40.417287, -76.453077); \
UPSERT into system.locations VALUES ('region', 'us-west-1', 38.837522, -120.895824); \
UPSERT into system.locations VALUES ('region', 'us-west-2', 43.804133, -120.554201); \
UPSERT into system.locations VALUES ('region', 'ca-central-1', 56.130366, -106.346771); \
UPSERT into system.locations VALUES ('region', 'eu-central-1', 50.110922, 8.682127); \
UPSERT into system.locations VALUES ('region', 'eu-west-1', 53.142367, -7.692054); \
UPSERT into system.locations VALUES ('region', 'eu-west-2', 51.507351, -0.127758); \
UPSERT into system.locations VALUES ('region', 'eu-west-3', 48.856614, 2.352222); \
UPSERT into system.locations VALUES ('region', 'ap-northeast-1', 35.689487, 139.691706); \
UPSERT into system.locations VALUES ('region', 'ap-northeast-2', 37.566535, 126.977969); \
UPSERT into system.locations VALUES ('region', 'ap-northeast-3', 34.693738, 135.502165); \
UPSERT into system.locations VALUES ('region', 'ap-southeast-1', 1.352083, 103.819836); \
UPSERT into system.locations VALUES ('region', 'ap-southeast-2', -33.86882, 151.209296); \
UPSERT into system.locations VALUES ('region', 'ap-south-1', 19.075984, 72.877656); \
UPSERT into system.locations VALUES ('region', 'sa-east-1', -23.55052, -46.633309);"
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SELECT * FROM system.locations;"
```

### insert region locations -- gcp

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute=" \
UPSERT into system.locations VALUES ('region', 'us-east1', 33.836082, -81.163727); \
UPSERT into system.locations VALUES ('region', 'us-east4', 37.478397, -76.453077); \
UPSERT into system.locations VALUES ('region', 'us-central1', 42.032974, -93.581543); \
UPSERT into system.locations VALUES ('region', 'us-west1', 43.804133, -120.554201); \
UPSERT into system.locations VALUES ('region', 'northamerica-northeast1', 56.130366, -106.346771); \
UPSERT into system.locations VALUES ('region', 'europe-west1', 50.44816, 3.81886); \
UPSERT into system.locations VALUES ('region', 'europe-west2', 51.507351, -0.127758); \
UPSERT into system.locations VALUES ('region', 'europe-west3', 50.110922, 8.682127); \
UPSERT into system.locations VALUES ('region', 'europe-west4', 53.4386, 6.8355); \
UPSERT into system.locations VALUES ('region', 'europe-west6', 47.3769, 8.5417); \
UPSERT into system.locations VALUES ('region', 'asia-east1', 24.0717, 120.5624); \
UPSERT into system.locations VALUES ('region', 'asia-northeast1', 35.689487, 139.691706); \
UPSERT into system.locations VALUES ('region', 'asia-southeast1', 1.352083, 103.819836); \
UPSERT into system.locations VALUES ('region', 'australia-southeast1', -33.86882, 151.209296); \
UPSERT into system.locations VALUES ('region', 'asia-south1', 19.075984, 72.877656); \
UPSERT into system.locations VALUES ('region', 'southamerica-east1', -23.55052, -46.633309);"
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SELECT * FROM system.locations;"
```

### insert region locations -- azure

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute=" \
UPSERT into system.locations VALUES ('region', 'eastasia', 22.267, 114.188); \
UPSERT into system.locations VALUES ('region', 'southeastasia', 1.283, 103.833); \
UPSERT into system.locations VALUES ('region', 'centralus', 41.5908, -93.6208); \
UPSERT into system.locations VALUES ('region', 'eastus', 37.3719, -79.8164); \
UPSERT into system.locations VALUES ('region', 'eastus2', 36.6681, -78.3889); \
UPSERT into system.locations VALUES ('region', 'westus', 37.783, -122.417); \
UPSERT into system.locations VALUES ('region', 'northcentralus', 41.8819, -87.6278); \
UPSERT into system.locations VALUES ('region', 'southcentralus', 29.4167, -98.5); \
UPSERT into system.locations VALUES ('region', 'northeurope', 53.3478, -6.2597); \
UPSERT into system.locations VALUES ('region', 'westeurope', 52.3667, 4.9); \
UPSERT into system.locations VALUES ('region', 'japanwest', 34.6939, 135.5022); \
UPSERT into system.locations VALUES ('region', 'japaneast', 35.68, 139.77); \
UPSERT into system.locations VALUES ('region', 'brazilsouth', -23.55, -46.633); \
UPSERT into system.locations VALUES ('region', 'australiaeast', -33.86, 151.2094); \
UPSERT into system.locations VALUES ('region', 'australiasoutheast', -37.8136, 144.9631); \
UPSERT into system.locations VALUES ('region', 'southindia', 12.9822, 80.1636); \
UPSERT into system.locations VALUES ('region', 'centralindia', 18.5822, 73.9197); \
UPSERT into system.locations VALUES ('region', 'westindia', 19.088, 72.868); \
UPSERT into system.locations VALUES ('region', 'canadacentral', 43.653, -79.383); \
UPSERT into system.locations VALUES ('region', 'canadaeast', 46.817, -71.217); \
UPSERT into system.locations VALUES ('region', 'uksouth', 50.941, -0.799); \
UPSERT into system.locations VALUES ('region', 'ukwest', 53.427, -3.084); \
UPSERT into system.locations VALUES ('region', 'westcentralus', 40.890, -110.234); \
UPSERT into system.locations VALUES ('region', 'westus2', 47.233, -119.852); \
UPSERT into system.locations VALUES ('region', 'koreacentral', 37.5665, 126.9780); \
UPSERT into system.locations VALUES ('region', 'koreasouth', 35.1796, 129.0756); \
UPSERT into system.locations VALUES ('region', 'francecentral', 46.3772, 2.3730); \
UPSERT into system.locations VALUES ('region', 'francesouth', 43.8345, 2.1972);"
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SELECT * FROM system.locations;"
```

## Run the TPCC load test

https://github.com/jhatcher9999/tpcc-distributed-k8s

### Initialize warehouses

refer also to this: https://github.com/jhatcher9999/tpcc-distributed-k8s

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="DROP DATABASE IF EXISTS tpcc CASCADE;"


oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach workload init tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --warehouses 2500 --partitions=3 --survival-goal region --regions=us-east-1,us-west-2,us-east-2 --drop 

# oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach workload fixtures import tpcc --warehouses=2500 --replicate-static-columns 'postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require'

export infrastructure=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.spec.platformSpec.type}'| tr '[:upper:]' '[:lower:]')
case ${infrastructure} in
  aws)
    export main_region=us-east-1
    export secondary_regions=( us-east-2 us-west-2 )
  ;;
  gcp)
    export main_region=us-east4
    export secondary_regions=( us-central1 us-west1 )
  ;;
  azure)
    export main_region=eastus2
    export secondary_regions=( centralus westus2 )
  ;;
esac



oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="ALTER DATABASE tpcc PRIMARY REGION "'"'"${main_region}"'"'";"

for secondary_region in ${secondary_regions[@]}; do
  oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="ALTER DATABASE tpcc ADD REGION "'"'"${secondary_region}"'"'";"
done  

oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="ALTER DATABASE tpcc SURVIVE REGION FAILURE;"

oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SHOW REGIONS FROM DATABASE tpcc;"

oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SELECT * FROM [SHOW RANGES FROM database tpcc] WHERE 'start_key' NOT LIKE '%Prefix%';"


#Kick off workload
oc --context ${cluster1} exec ${tools_pod} -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc --warehouses=10 --duration=10m 'postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require' 

```

This can take about three hours to complete.

### Run tests

open three terminals, try to start the following commands at the same time

in terminal one run

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster1 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 2500 --ramp=180s --partition-affinity=0 --partitions=3 --survival-goal region --regions=us-east-1,us-west-2,us-east-2 --tolerate-errors | tee ./cluster1.log
```

in terminal two run:

```shell
export tools_pod=$(oc --context cluster2 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster2 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 2500 --ramp=180s --partition-affinity=1 --partitions=3 --survival-goal region --regions=us-east-1,us-west-2,us-east-2 --tolerate-errors | tee ./cluster2.log
```
  
in terminal three run

```shell
export tools_pod=$(oc --context cluster3 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster3 exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach workload run tpcc postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require --duration=60m --warehouses 2500 --ramp=180s --partition-affinity=2 --partitions=3 --survival-goal region --regions=us-east-1,us-west-2,us-east-2 --tolerate-errors | tee ./cluster3.log
```

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

Enter a sql shell

```shell
export tools_pod=$(oc --context cluster1 get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context cluster1 exec -ti $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --url postgresql://dba:dba@cockroachdb-public.cockroachdb.svc.cluster.local:26257?sslmode=require
```

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
  oc --context ${context} delete pvc --all -n cockroachdb
done
```
