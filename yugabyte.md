# Install Yugabyte

## Create adequate nodes

```shell
export infrastructure=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.spec.platformSpec.type}'| tr '[:upper:]' '[:lower:]')
for cluster in ${cluster1} ${cluster2} ${cluster3}; do
  #helm --kube-context ${control_cluster} uninstall yugabyte-machine-pool -n ${cluster}
  envsubst < ./yugabyte/machinepool-values.templ.yaml > /tmp/values.yaml 
  helm --kube-context ${control_cluster} upgrade yugabyte-machine-pool ./charts/machine-pool -n ${cluster} --atomic -i -f /tmp/values.yaml
done
```

## Deploy yugabyte DB

```shell
export infrastructure=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.spec.platformSpec.type}'| tr '[:upper:]' '[:lower:]')
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project yugabyte
  export cluster=${context}
  export uid=$(oc --context ${context} get project yugabyte -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.uid-range}'|sed 's/\/.*//')
  export guid=$(oc --context ${context} get project yugabyte -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}'|sed 's/\/.*//')  
  envsubst < ./yugabyte/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade yugabyte ./charts/yugabyte -i -n yugabyte --create-namespace -f /tmp/values.yaml
done
```

### Add grafana for monitoring

Install operators

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export namespace=yugabyte
  envsubst < ./yugabyte/tenant-monitoring-operator.yaml | oc --context ${context} apply -f - -n yugabyte
done
```

Install monitoring stack

Note this script tends to fail as helm does not handle well large charts. It's mostly safe to retry.

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export prometheus_password=$(oc --context ${context} extract secret/grafana-datasources -n openshift-monitoring --keys=prometheus.yaml --to=- | jq -r '.datasources[0].basicAuthPassword')
  envsubst < ./yugabyte/values.monitoring-stack.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade monitoring-stack ./charts/monitoring-stack --atomic -i -n yugabyte --create-namespace -f /tmp/values.yaml
  export grafana_token=$(oc --context ${context} sa get-token grafana-serviceaccount -n yugabyte)
  envsubst < ./yugabyte/grafana-datasource-prometheus.templ.yaml | oc --context ${context} apply -f - -n yugabyte
done
```

## Running the tpcc benchmark

### Change pid limit

The yugabyte tpcc test run as a java client that create multiple pods, run the following command to enable the container to create a high number of java threads

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} apply -f ./yugabyte/high-pids-machine-config.yaml
done
```

This will likely reboot all of your nodes, so it might take a while

### Workaround pkcs8 certificates

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} get secret yugabyte-tls-client-cert -n yugabyte -o jsonpath='{.data.tls\.key}' | base64 -d > /tmp/key.pem
  openssl pkcs8 -topk8 -inform PEM -in /tmp/key.pem -outform DER -out /tmp/key.pk8 -v1 PBE-MD5-DES -nocrypt
  export key=$(cat /tmp/key.pk8 | base64 -w 0)
  oc --context ${context} patch secret yugabyte-tls-client-cert -n yugabyte --patch "$(envsubst < ./yugabyte/cert-patch.yaml)" --type merge
done
```

### Set preferential regions

aws

```shell
oc --context ${cluster1} exec -n yugabyte -c yb-master yb-master-0 -- /usr/local/bin/yb-admin --master_addresses yb-master-0.cluster1.yb-masters.yugabyte.svc.clusterset.local:7100,yb-master-0.cluster2.yb-masters.yugabyte.svc.clusterset.local:7100,yb-master-0.cluster3.yb-masters.yugabyte.svc.clusterset.local:7100 --certs_dir_name /opt/certs/yugabyte modify_placement_info aws.us-east-1,aws.us-east-2,aws.us-west-2 3
```

azure

```shell
oc --context ${cluster1} exec -n yugabyte -c yb-master yb-master-0 -- /usr/local/bin/yb-admin --master_addresses yb-master-0.cluster1.yb-masters.yugabyte.svc.clusterset.local:7100,yb-master-0.cluster2.yb-masters.yugabyte.svc.clusterset.local:7100,yb-master-0.cluster3.yb-masters.yugabyte.svc.clusterset.local:7100 --certs_dir_name /opt/certs/yugabyte modify_placement_info azure.eastus2,azure.centralus,azure.westus2 3
```

google

```shell
oc --context ${cluster1} exec -n yugabyte -c yb-master yb-master-0 -- /usr/local/bin/yb-admin --master_addresses yb-master-0.cluster1.yb-masters.yugabyte.svc.clusterset.local:7100,yb-master-0.cluster2.yb-masters.yugabyte.svc.clusterset.local:7100,yb-master-0.cluster3.yb-masters.yugabyte.svc.clusterset.local:7100 --certs_dir_name /opt/certs/yugabyte modify_placement_info gcp.us-east4.myzone,gcp.us-central1.myzone,gcp.us-west1.myzone 3
```

### Create helper pod

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export namespace=yugabyte
  envsubst < ./yugabyte/helper-pod.yaml | oc --context ${context} apply -f - -n yugabyte
  oc --context ${context} start-build tpcc-runner-pom-build -n yugabyte
done
```

wait for the pod to come up

### Load data

```shell
export helper_pod=$(oc --context ${cluster1} get pod -n yugabyte | grep tpccbenchmark-helper-pod | awk '{print $1}')
oc --context ${cluster1} exec -n yugabyte ${helper_pod} -- ln -sf /tmp/src/config ./config
export warehouses=1000
oc --context ${cluster1} exec -n yugabyte ${helper_pod} -- java -Xmx8G -Dlog4j.configuration=/workload-config/log4j.properties -jar /deployments/oltpbench-1.0-jar-with-dependencies.jar --create=true --warehouses=${warehouses} --loaderthreads 36 -c /workload-config/workload.xml --nodes=yb-tserver-0.yb-tservers.yugabyte.svc,yb-tserver-1.yb-tservers.yugabyte.svc,yb-tserver-2.yb-tservers.yugabyte.svc
oc --context ${cluster1} exec -n yugabyte ${helper_pod} -- java -Xmx8G -Dlog4j.configuration=/workload-config/log4j.properties -jar /deployments/oltpbench-1.0-jar-with-dependencies.jar --load=true --warehouses=${warehouses} --loaderthreads 36 -c /workload-config/workload.xml --nodes=yb-tserver-0.yb-tservers.yugabyte.svc,yb-tserver-1.yb-tservers.yugabyte.svc,yb-tserver-2.yb-tservers.yugabyte.svc
```

### Run tests

open three terminals, try to start the following commands at the same time

in terminal one run

```shell
export helper_pod=$(oc --context cluster1 get pod -n yugabyte | grep tpccbenchmark-helper-pod | awk '{print $1}')
oc --context cluster1 exec -n yugabyte ${helper_pod} -- ln -sf /tmp/src/config ./config
oc --context cluster1 exec -n yugabyte ${helper_pod} -- java -Xmx8G -Dlog4j.configuration=/workload-config/log4j.properties -jar /deployments/oltpbench-1.0-jar-with-dependencies.jar -c /workload-config/workload.xml --warehouses=334 --execute=true --num-connections=600 --start-warehouse-id=1 --total-warehouses=1000 --warmup-time-secs=60 --im=5000 -vv --nodes=yb-tserver-0.yb-tservers.yugabyte.svc,yb-tserver-1.yb-tservers.yugabyte.svc,yb-tserver-2.yb-tservers.yugabyte.svc
```

in terminal two run:

```shell
export helper_pod=$(oc --context cluster2 get pod -n yugabyte | grep tpccbenchmark-helper-pod | awk '{print $1}')
oc --context cluster2 exec -n yugabyte ${helper_pod} -- ln -sf /tmp/src/config ./config
oc --context cluster2 exec -n yugabyte ${helper_pod} -- java -Xmx8G -Dlog4j.configuration=/workload-config/log4j.properties -jar /deployments/oltpbench-1.0-jar-with-dependencies.jar -c /workload-config/workload.xml --warehouses=333 --execute=true --num-connections=600 --start-warehouse-id=335 --total-warehouses=1000 --warmup-time-secs=60 --im=5000 -vv --nodes=yb-tserver-0.yb-tservers.yugabyte.svc,yb-tserver-1.yb-tservers.yugabyte.svc,yb-tserver-2.yb-tservers.yugabyte.svc
```
  
in terminal three run

```shell
export helper_pod=$(oc --context cluster3 get pod -n yugabyte | grep tpccbenchmark-helper-pod | awk '{print $1}')
oc --context cluster3 exec -n yugabyte ${helper_pod} -- ln -sf /tmp/src/config ./config
oc --context cluster3 exec -n yugabyte ${helper_pod} -- java -Xmx8G -Dlog4j.configuration=/workload-config/log4j.properties -jar /deployments/oltpbench-1.0-jar-with-dependencies.jar -c /workload-config/workload.xml --warehouses=333 --execute=true --num-connections=600 --start-warehouse-id=668 --total-warehouses=1000 --warmup-time-secs=60 --im=5000 -vv --nodes=yb-tserver-0.yb-tservers.yugabyte.svc,yb-tserver-1.yb-tservers.yugabyte.svc,yb-tserver-2.yb-tservers.yugabyte.svc
```

## Run the disaster recovery test

Run the tpcc test as described above.

### AWS

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

### GCP

Isolate us-west4 region

```shell
export gcp_project_id=$(cat ~/.gcp/osServiceAccount.json | jq -r .project_id)
export infrastructure_3=$(oc --context cluster3 get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
gcloud compute --project=${gcp_project_id} firewall-rules create deny-all-egress --direction=EGRESS --priority=0 --network=${infrastructure_3}-network --action=DENY --rules=all --destination-ranges=0.0.0.0/0 --target-tags=${infrastructure_3}-worker,${infrastructure_3}-master
gcloud compute --project=${gcp_project_id} firewall-rules create deny-all-ingress --direction=INGRESS --priority=0 --network=${infrastructure_3}-network --action=DENY --rules=all --source-ranges=0.0.0.0/0 --target-tags=${infrastructure_3}-worker,${infrastructure_3}-master
```

observe the behavior

Reinstate traffic

```shell
gcloud compute --project=${gcp_project_id} firewall-rules delete deny-all-egress --quiet
gcloud compute --project=${gcp_project_id} firewall-rules delete deny-all-ingress --quiet
```

## Troubleshooting

### Restart pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} rollout restart statefulset -n yugabyte
done
```

### Rescale pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} scale statefulset yb-master --replicas 0 -n yugabyte
  oc --context ${context} scale statefulset yb-tserver --replicas 0 -n yugabyte
  oc --context ${context} scale statefulset yb-master --replicas 1 -n yugabyte
  oc --context ${context} scale statefulset yb-tserver --replicas 3 -n yugabyte
done
```

### Uninstall yugabyte

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall yugabyte -n yugabyte
  oc --context ${context} delete pvc --all -n yugabyte
done
```

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall monitoring-stack -n yugabyte
done
```

### Cleanup

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} delete project yugabyte
done
```
