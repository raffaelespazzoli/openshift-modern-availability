# OpenShift modern availability

This is a step by step tutorial to deploying stateful application with high availability and zero downtime DR (RTO,RPO~>0).
You will need a cluster and the ability to spawn new ones.
This tutorial works on AWS, but the concepts maybe reused everywhere.

## Deploy RHACM

```shell
export docker_username=<rhacm_docker_username>
export docker_password=<rhacm_docker_password>
oc new-project open-cluster-management
oc apply -f ./acm/operator.yaml -n open-cluster-management
oc create secret docker-registry acm-pull-secret --docker-server=registry.access.redhat.com/rhacm1-tech-preview --docker-username=${docker_username} --docker-password=${docker_password} -n open-cluster-management
oc apply -f ./acm/acm.yaml -n open-cluster-management
```

RHACM requires significant resources, check that the RHACM pods are not stuck in `container creating` and nodes if needed.
Wait until all pods are started successfully.

## Create three managed clusters

```shell
export ssh_key=$(cat ~/.ssh/ocp_rsa | sed 's/^/  /')
export ssh_pub_key=$(cat ~/.ssh/ocp_rsa.pub)
export pull_secret=$(cat ~/git/openshift-enablement-exam/4.0/config/pullsecret.json)
export aws_id=$(cat ~/.aws/credentials | grep aws_access_key_id | cut -d'=' -f 2)
export aws_key=$(cat ~/.aws/credentials | grep aws_secret_access_key | cut -d'=' -f 2)
export base_domain=$(oc get dns cluster -o jsonpath='{.spec.baseDomain}')
export base_domain=${base_domain#*.}
```

create clusters

```shell
export region="us-east-1"
envsubst < ./acm/acm-cluster-values.yaml > /tmp/values.yaml
helm upgrade cluster1 ./charts/acm-aws-cluster --create-namespace -i -n cluster1  -f /tmp/values.yaml

export region="us-east-2"
envsubst < ./acm/acm-cluster-values.yaml > /tmp/values.yaml
helm upgrade cluster2 ./charts/acm-aws-cluster --create-namespace -i -n cluster2  -f /tmp/values.yaml

export region="us-west-2"
envsubst < ./acm/acm-cluster-values.yaml > /tmp/values.yaml
helm upgrade cluster3 ./charts/acm-aws-cluster --create-namespace -i -n cluster3  -f /tmp/values.yaml
```

Wait about 40 minutes

### Prepare login config contexts

```shell
export control_cluster=$(oc config current-context)
for cluster in cluster1 cluster2 cluster3; do
  oc config use-context ${control_cluster}
  password=$(oc get secret $(oc get clusterdeployment ${cluster} -n ${cluster} -o jsonpath='{.spec.clusterMetadata.adminPasswordSecretRef.name}') -n ${cluster} -o jsonpath='{.data.password}' | base64 -d)
  url=$(oc get clusterdeployment ${cluster} -n ${cluster} -o jsonpath='{.status.apiURL}')
  oc login -u kubeadmin -p ${password} ${url}
  export ${cluster}=$(oc config current-context)
done
oc config use-context ${control_cluster}
```

### Export needed variable for following steps

```shell
export cluster1_service_name=router-default
export cluster2_service_name=router-default
export cluster3_service_name=router-default
export cluster1_service_namespace=openshift-ingress
export cluster2_service_namespace=openshift-ingress
export cluster3_service_namespace=openshift-ingress
export cluster1_secret_name=$(oc --context ${control_cluster} get clusterdeployment cluster1 -n cluster1 -o jsonpath='{.spec.clusterMetadata.adminKubeconfigSecretRef.name}')
export cluster2_secret_name=$(oc --context ${control_cluster} get clusterdeployment cluster2 -n cluster2 -o jsonpath='{.spec.clusterMetadata.adminKubeconfigSecretRef.name}')
export cluster3_secret_name=$(oc --context ${control_cluster} get clusterdeployment cluster3 -n cluster3 -o jsonpath='{.spec.clusterMetadata.adminKubeconfigSecretRef.name}')
```

## Deploy global-load-balancer-operator

### Create global zone

This will create a global zone called `global.<cluster-base-domain>` with associate zone delegation.

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export cluster_zone_id=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.publicZone.id}')
export global_base_domain=global.${cluster_base_domain#*.}
aws route53 create-hosted-zone --name ${global_base_domain} --caller-reference $(date +"%m-%d-%y-%H-%M-%S-%N") 
export global_zone_res=$(aws route53 list-hosted-zones-by-name --dns-name ${global_base_domain} | jq -r .HostedZones[0].Id )
export global_zone_id=${global_zone_res##*/}
export delegation_record=$(aws route53 list-resource-record-sets --hosted-zone-id ${global_zone_id} | jq .ResourceRecordSets[0])
envsubst < ./global-load-balancer-operator/delegation-record.json > /tmp/delegation-record.json
aws route53 change-resource-record-sets --hosted-zone-id ${cluster_zone_id} --change-batch file:///tmp/delegation-record.json
```

### Deploy operator

```shell
export namespace=global-load-balancer-operator
oc --context ${control_cluster} new-project ${namespace}
oc --context ${control_cluster} apply -f https://raw.githubusercontent.com/kubernetes-sigs/external-dns/master/docs/contributing/crd-source/crd-manifest.yaml
oc --context ${control_cluster} apply -f ./global-load-balancer-operator/operator.yaml -n ${namespace}
envsubst < ./global-load-balancer-operator/route53-credentials-request.yaml | oc apply -f - -n ${namespace}
envsubst < ./global-load-balancer-operator/route53-dns-zone.yaml | oc apply -f -
envsubst < ./global-load-balancer-operator/route53-global-route-discovery.yaml | oc apply -f - -n ${namespace}
```

## Deploy Submariner (network tunnel)

### Prepare nodes for submariner

```shell
git clone https://github.com/submariner-io/submariner
for context in ${cluster1} ${cluster2} ${cluster3}; do
  cluster_id=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  cluster_region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  echo $cluster_id $cluster_region
  mkdir -p /tmp/${cluster_id}
  cp -R ./submariner/tools/openshift/ocp-ipi-aws/* /tmp/${cluster_id}
  sed -i "s/\"cluster_id\"/\"${cluster_id}\"/g" /tmp/${cluster_id}/main.tf
  sed -i "s/\"aws_region\"/\"${cluster_region}\"/g" /tmp/${cluster_id}/main.tf
  pushd /tmp/${cluster_id}
  terraform init -upgrade=true
  terraform apply -auto-approve
  popd
  oc --context=${context} apply -f /tmp/${cluster_id}/submariner-gw-machine*.yaml
done
```

### Deploy submariner

```shell
helm repo add submariner-latest https://submariner-io.github.io/submariner-charts/charts
```

Deploy the broker

```shell
oc --context ${context_cluster_control} new-project submariner-broker
oc --context ${context_cluster_control} apply -f ./submariner/submariner-crds.yaml
helm upgrade submariner-broker submariner-latest/submariner-k8s-broker --kube-context ${context_cluster_control} -i --create-namespace -f ./submariner/values-sm-broker.yaml -n submariner-broker
```

Deploy submariner

```shell
export broker_api=${$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.status.apiServerURL}')#"https"}
export broker_api=${broker_api#"https://"}
#$(oc --context ${control_cluster} -n default get endpoints kubernetes -o jsonpath="{.subsets[0].addresses[0].ip}:{.subsets[0].ports[?(@.name=='https')].port}")
export broker_ca=$(oc --context ${control_cluster} get secret $(oc --context ${control_cluster} get sa default -n default -o yaml | grep token | awk '{print $3}') -n default -o jsonpath='{.data.ca\.crt}')
export broker_token=$(oc --context ${control_cluster} get secret $(oc --context ${control_cluster} get sa submariner-broker-submariner-k8s-broker-client -n submariner-broker -o yaml | grep token | awk '{print $3}') -n submariner-broker -o jsonpath='{.data.token}' | base64 -d)
export SUBMARINER_PSK=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster_cidr=$(oc --context ${context} get network cluster -o jsonpath='{.status.clusterNetwork[0].cidr}')
  export cluster_service_cidr=$(oc --context ${context} get network cluster -o jsonpath='{.status.serviceNetwork[0]}')
  export cluster_id=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  oc --context ${context} apply -f ./submariner/submariner-crds.yaml
  envsubst < ./submariner/values-sm.yaml > /tmp/values-sm.yaml
  #helm upgrade submariner submariner-latest/submariner --kube-context ${context} -i --create-namespace -f /tmp/values-sm.yaml -n submariner
  oc --context ${context} new-project submariner
  oc --context ${context} adm policy add-scc-to-user privileged -z submariner-engine -n submariner
  oc --context ${context} adm policy add-scc-to-user privileged -z submariner-routeagent -n submariner
  helm template submariner ./charts/submariner --kube-context ${context} --create-namespace -f /tmp/values-sm.yaml -n submariner | oc --context ${context} apply -f - -n submariner
done
```
