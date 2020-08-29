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
export network_cidr="10.128.0.0/14"
export service_cidr="172.30.0.0/16"
envsubst < ./acm/acm-cluster-values.yaml > /tmp/values.yaml
helm upgrade cluster1 ./charts/acm-aws-cluster --create-namespace -i -n cluster1  -f /tmp/values.yaml

export region="us-east-2"
export network_cidr="10.132.0.0/14"
export service_cidr="172.31.0.0/16"
envsubst < ./acm/acm-cluster-values.yaml > /tmp/values.yaml
helm upgrade cluster2 ./charts/acm-aws-cluster --create-namespace -i -n cluster2  -f /tmp/values.yaml

export region="us-west-2"
export network_cidr="10.136.0.0/14"
export service_cidr="172.32.0.0/16"
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
envsubst < ./global-load-balancer-operator/route53-credentials-request.yaml | oc --context ${control_cluster} apply -f - -n ${namespace}
envsubst < ./global-load-balancer-operator/route53-dns-zone.yaml | oc --context ${control_cluster} apply -f -
envsubst < ./global-load-balancer-operator/route53-global-route-discovery.yaml | oc --context ${control_cluster} apply -f - -n ${namespace}
```

## Deploy Submariner (network tunnel)

### Prepare nodes for submariner

```shell
git -C /tmp clone https://github.com/submariner-io/submariner
for context in ${cluster1} ${cluster2} ${cluster3}; do
  cluster_id=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  cluster_region=$(oc --context ${context} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
  echo $cluster_id $cluster_region
  mkdir -p /tmp/${cluster_id}
  cp -R /tmp/submariner/tools/openshift/ocp-ipi-aws/* /tmp/${cluster_id}
  sed -i "s/\"cluster_id\"/\"${cluster_id}\"/g" /tmp/${cluster_id}/main.tf
  sed -i "s/\"aws_region\"/\"${cluster_region}\"/g" /tmp/${cluster_id}/main.tf
  pushd /tmp/${cluster_id}
  terraform init -upgrade=true
  terraform apply -auto-approve
  popd
  oc --context=${context} apply -f /tmp/${cluster_id}/submariner-gw-machine*.yaml
done
```

### Deploy submariner via helm chart (do not use)

```shell
helm repo add submariner-latest https://submariner-io.github.io/submariner-charts/charts
```

Deploy the broker

```shell
oc --context ${control_cluster} new-project submariner-broker
oc --context ${control_cluster} apply -f ./submariner/submariner-crds.yaml
helm upgrade submariner-broker submariner-latest/submariner-k8s-broker --kube-context ${control_cluster} -i --create-namespace -f ./submariner/values-sm-broker.yaml -n submariner-broker
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

### Deploy submariner via CLI

```shell
subctl deploy-broker --kubecontext ${control_cluster} --service-discovery
mv broker-info.subm /tmp/broker-info.subm
for context in ${cluster1} ${cluster2} ${cluster3}; do
  subctl join --kubecontext ${context} /tmp/broker-info.subm --no-label --clusterid $(echo ${context} | cut -d "/" -f2 | cut -d "-" -f2)
done
```

## Deploy Vault

### Create vault root key (rootca and KMS key)

```shell
export region=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
export key_id=$(aws --region ${region} kms create-key | jq -r .KeyMetadata.KeyId)
oc --context ${control_cluster} new-project vault
oc --context ${control_cluster} create secret generic vault-kms -n vault --from-literal=key_id=${key_id}
oc --context ${control_cluster} apply -f ./vault/vault-control-cluster-certs.yaml -n vault
export rootca_crt=$(oc --context ${control_cluster} get secret rootca -n vault -o jsonpath='{.data.tls\.crt}')
export rootca_key=$(oc --context ${control_cluster} get secret rootca -n vault -o jsonpath='{.data.tls\.key}')
```

### Deploy cert-manager and cert-utils-operator

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project cert-manager
  oc --context ${context} apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml
  oc --context ${context} new-project cert-utils-operator
  oc --context ${context} apply  -f ./cert-utils-operator/operator.yaml -n cert-utils-operator
done
```

### Deploy Vault instances

```shell
export rootca_crt=$(oc --context ${control_cluster} get secret rootca -n vault -o jsonpath='{.data.tls\.crt}')
export rootca_key=$(oc --context ${control_cluster} get secret rootca -n vault -o jsonpath='{.data.tls\.key}')
export key_id=$(oc --context ${control_cluster} get secret vault-kms -n vault -o jsonpath='{.data.key_id}' | base64 -d )
export region=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
helm dependency update ./charts/vault-multicluster
for context in ${cluster1} ${cluster2} ${cluster3}; do
  envsubst < ./vault/kms-values.yaml.template > /tmp/values.yaml
  helm --kube-context ${context} upgrade vault ./charts/vault-multicluster -i --create-namespace -n vault -f /tmp/values.yaml
done
```

### Initialize Vault (run once-only)

```shell
HA_INIT_RESPONSE=$(oc --context ${cluster1} exec vault-0 -n vault -- vault operator init -address https://vault-0.cluster-1.vault-internal.vault.svc.clusterset.local:8200 -ca-path /etc/vault-tls/vault-tls/ca.crt -format=json -recovery-shares 1 -recovery-threshold 1)

HA_UNSEAL_KEY=$(echo "$HA_INIT_RESPONSE" | jq -r .recovery_keys_b64[0])
HA_VAULT_TOKEN=$(echo "$HA_INIT_RESPONSE" | jq -r .root_token)

echo "$HA_UNSEAL_KEY"
echo "$HA_VAULT_TOKEN"

#here we are saving these variable in a secret, this is probably not what you should do in a production environment
oc --context ${control_cluster} create secret generic vault-init -n vault --from-literal=unseal_key=${HA_UNSEAL_KEY} --from-literal=root_token=${HA_VAULT_TOKEN}
```

### Verify Vault Cluster Health

```shell
oc --context ${cluster1} exec vault-0 -n vault -- sh -c "VAULT_TOKEN=${HA_VAULT_TOKEN} vault operator raft list-peers -address https://vault-0.cluster-1.vault-internal.vault.svc.clusterset.local:8200 -ca-path /etc/vault-tls/vault-tls/ca.crt"
```

### Testing vault external connectivity

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath '{data.root_token}' | base64 -d )
vault status -tls-skip-verify
```

### Access Vault UI

browse to here

```shell
echo $VAULT_ADDR/ui
```

## Vault cert-manager integration

With this integration we enable the previously installed cert-manager to create certificates via vault.

### Prepare Kubernetes authentication

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath '{data.root_token}'| base64 -d )
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export clusterid=$(echo ${context} | cut -d "/" -f2 | cut -d "-" -f2)
  vault auth enable -tls-skip-verify kubernetes --path=kubernetes-${clusterid}
  export sa_secret_name=$(oc --context ${context} get sa vault -n vault -o jsonpath='{.secrets[*].name}' | grep -o '\b\w*\-token-\w*\b')
  oc --context ${context} get secret ${sa_secret_name} -n vault -o jsonpath='{.data.ca\.crt}' | base64 -d > /tmp/ca.crt
  vault write -tls-skip-verify auth/kubernetes-${clusterid}/config token_reviewer_jwt="$(oc --context ${context} serviceaccounts get-token vault -n vault)" kubernetes_host=https://kubernetes.default.svc:443 kubernetes_ca_cert=@/tmp/ca.crt
  vault write -tls-skip-verify auth/kubernetes-${clusterid}/role/cert-manager bound_service_account_names=default bound_service_account_namespaces=cert-manager policies=default,cert-manager
done
```

### Prepare vault pki

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath '{data.root_token}'| base64 -d )
vault secrets enable -tls-skip-verify pki
vault write -tls-skip-verify pki/root/generate/internal common_name=cert-manager.cluster.local
vault write -tls-skip-verify pki/config/urls issuing_certificates="http://vault.vault.svc:8200/v1/pki/ca" crl_distribution_points="http://vault.vault.svc:8200/v1/pki/crl"
vault write -tls-skip-verify pki/roles/cert-manager allowed_domains=svc,svc.cluster.local allow_subdomains=true allow_localhost=false
vault policy write -tls-skip-verify cert-manager ./vault/cert-manager-policy.hcl
```

### Prepare cert-manager Cluster Issuer

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export vault_ca=$(oc --context ${context} get secret vault-tls -n vault -o jsonpath='{.data.ca\.crt}')
  export sa_secret_name=$(oc --context ${context} get sa default -n cert-manager -o jsonpath='{.secrets[*].name}' | grep -o '\b\w*\-token-\w*\b')
  export clusterid=$(echo ${context} | cut -d "/" -f2 | cut -d "-" -f2)
  envsubst < vault-issuer.yaml | oc --context ${context} apply -f - -n cert-manager
done  
```

## Deploy cockroachDB

### Deploy CRDB

```shell
helm repo add cockroachdb https://charts.cockroachdb.com/
helm dependency update ./charts/vault-multicluster
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  envsubst < ./cockroachdb/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade cockroachdb ./charts/cockroachdb-multicluster -i --create-namespace -n cockroachdb -f /tmp/values.yaml --set conf.locality=cluster=$(echo ${context} | cut -d "/" -f2 | cut -d "-" -f2)
done
```