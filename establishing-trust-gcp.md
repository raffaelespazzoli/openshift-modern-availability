# Establishing Trust

We need to establish some form of trust between the cluster before starting to deploy stateful workloads.
In practice this means that the applications deployed to these clusters will have a common source for their secrets, certificates and credentials in general.
In this step we are going to use Vault as our secret manager and we are going to deploy Vault in these cluster themselves.

## Deploy Vault

### Create vault root keys (rootca and google KMS key)

```shell
gcloud kms keyrings create "acm" --location "global"
gcloud kms keys create "vault" --location "global" --keyring "acm" --purpose "encryption"
oc --context ${control_cluster} new-project vault
oc --context ${control_cluster} apply -f ./vault/vault-control-cluster-certs.yaml -n vault
```

### Deploy cert-manager, cert-utils-operator and reloader

```shell
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project cert-manager
  oc --context ${context} apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.yaml
  oc --context ${context} new-project cert-utils-operator
  oc --context ${context} apply  -f ./cert-utils-operator/operator.yaml -n cert-utils-operator
  oc new-project reloader
  export uid=$(oc --context ${context} get project reloader -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.uid-range}'|sed 's/\/.*//')
  helm --kube-context ${context} upgrade reloader stakater/reloader -i --create-namespace -n reloader --set reloader.deployment.securityContext.runAsUser=${uid}
done
```

### Deploy Vault instances

```shell
export rootca_crt=$(oc --context ${control_cluster} get secret rootca -n vault -o jsonpath='{.data.tls\.crt}')
export rootca_key=$(oc --context ${control_cluster} get secret rootca -n vault -o jsonpath='{.data.tls\.key}')
#export key_id=$(oc --context ${control_cluster} get secret vault-kms -n vault -o jsonpath='{.data.key_id}' | base64 -d )
#export region=$(oc --context ${control_cluster} get infrastructure cluster -o jsonpath='{.status.platformStatus.aws.region}')
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export gcp_project_id=$(cat ~/.gcp/osServiceAccount.json | jq -r .project_id)
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  envsubst < ./vault/kms-values-gcp.yaml.template > /tmp/values.yaml
  helm --kube-context ${context} upgrade vault ./charts/vault-multicluster -i --create-namespace -n vault -f /tmp/values.yaml
done
```

### Initialize Vault (run once-only)

```shell
HA_INIT_RESPONSE=$(oc --context ${cluster1} exec vault-0 -n vault -- vault operator init -address https://vault-0.cluster1.vault-internal.vault.svc.clusterset.local:8200 -ca-path /etc/vault-tls/ca.crt -format=json -recovery-shares 1 -recovery-threshold 1)

HA_UNSEAL_KEY=$(echo "$HA_INIT_RESPONSE" | jq -r .recovery_keys_b64[0])
HA_VAULT_TOKEN=$(echo "$HA_INIT_RESPONSE" | jq -r .root_token)

echo "$HA_UNSEAL_KEY"
echo "$HA_VAULT_TOKEN"

#here we are saving these variable in a secret, this is probably not what you should do in a production environment
oc --context ${control_cluster} delete secret vault-init -n vault
oc --context ${control_cluster} create secret generic vault-init -n vault --from-literal=unseal_key=${HA_UNSEAL_KEY} --from-literal=root_token=${HA_VAULT_TOKEN}
```

### Verify Vault Cluster Health

```shell
oc --context ${cluster1} exec vault-0 -n vault -- sh -c "VAULT_TOKEN=${HA_VAULT_TOKEN} vault operator raft list-peers -address https://vault-0.cluster1.vault-internal.vault.svc.clusterset.local:8200 -ca-path /etc/vault-tls/ca.crt"
```

### Manually create global load balancer

This will need to be automated with an operator.

DNS->global VIP->forwarding rule->target https proxy->backend-service->[neg]->[ne]
                                  certificates
                                  url-map

```shell
# create global address
gcloud compute addresses create vault-global-ipv4 --ip-version=IPV4 --global
export vault_ip=$(gcloud --format json compute addresses describe vault-global-ipv4 --global | jq -r .address)

# create dns entry
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export global_base_domain_no_dots=$(echo ${global_base_domain} | tr '.' '-')
gcloud dns record-sets create vault.${global_base_domain} --rrdatas=${vault_ip} --type=A -z ${global_base_domain_no_dots}

# create health check 
gcloud compute https-health-checks create vault-https-health-check --host vault.${global_base_domain} --request-path /v1/sys/health

# create backend service
gcloud compute backend-services create vault-backend-service --global --https-health-checks vault-https-health-check --load-balancing-scheme EXTERNAL --protocol https --global-health-checks

# create network endpoint groups

for cluster in ${cluster1} ${cluster2} ${cluster3}; do
  region=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.platformStatus.gcp.region}')
  infrastructureName=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  network=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')-network
  subnet=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')-worker-subnet
  port=$(oc --context cluster1 get service router-default -n openshift-ingress -o json | jq -r '.spec.ports[] | select( .name=="https") | .nodePort')
  for zone in $(gcloud --format json compute zones list --filter region=${region} | jq -r .[].name); do
    gcloud compute network-endpoint-groups create vault-${zone} --network=${network} --subnet=${subnet} --default-port=443  --zone=${zone}
    for instance in $(gcloud --format json compute instances list --zones ${zone} --filter="labels.kubernetes-io-cluster-${infrastructureName}=owned" | jq -r .[].name); do
      gcloud compute network-endpoint-groups update vault-${zone} --zone=${zone} --add-endpoint "instance=${instance},port=${port}"
    done
    gcloud compute backend-services add-backend vault-backend-service --global --network-endpoint-group=vault-${zone} --network-endpoint-group-zone=${zone} --balancing-mode rate --max-rate-per-endpoint 100
  done
done

# create certificates
oc --context cluster1 get route vault-ui -n vault -o jsonpath='{.spec.tls.certificate}' > /tmp/tls.crt
oc --context cluster1 get route vault-ui -n vault -o jsonpath='{.spec.tls.key}' > /tmp/tls.key
gcloud compute ssl-certificates create vault-ssl-certificates --global --certificate=/tmp/tls.crt --private-key=/tmp/tls.key

# create url map
gcloud compute url-maps create vault-url-map --default-service vault-backend-service --global

# create target https proxy
gcloud compute target-https-proxies create vault-target-https-proxy --url-map vault-url-map --ssl-certificates vault-ssl-certificates --global-ssl-certificates --global-url-map 

# create forwarding rule

gcloud compute forwarding-rules create vault-forwarding-rule --global-backend-service --ip-protocol=TCP --address=vault-global-ipv4 --load-balancing-scheme=external --ports 443 --global --target-https-proxy=vault-target-https-proxy --global-target-https-proxy
```

DNS->global VIP->forwarding rule->target tcp proxy->backend-service->[neg]->[ne]
                                                    health-check

```shell
# create global address
gcloud compute addresses create vault-global-ipv4 --ip-version=IPV4 --global
export vault_ip=$(gcloud --format json compute addresses describe vault-global-ipv4 --global | jq -r .address)

# create dns entry
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export global_base_domain_no_dots=$(echo ${global_base_domain} | tr '.' '-')
gcloud dns record-sets create vault.${global_base_domain} --rrdatas=${vault_ip} --type=A -z ${global_base_domain_no_dots}

# allow health checks
for cluster in ${cluster1} ${cluster2} ${cluster3}; do
  export network=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')-network
  export infrastructure=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  gcloud compute firewall-rules create ${infrastructure}-fw-allow-health-checks --network=${network} --action=ALLOW --direction=INGRESS --source-ranges=35.191.0.0/16,130.211.0.0/22 --target-tags=${infrastructure}-worker --rules=tcp
done

# create health check 
gcloud compute health-checks create https vault-health-check --host vault.${global_base_domain} --request-path /v1/sys/health --use-serving-port --global

# create backend service
gcloud compute backend-services create vault-backend-service --global --health-checks vault-health-check --load-balancing-scheme EXTERNAL --protocol tcp --global-health-checks

# create network endpoint groups

for cluster in ${cluster1} ${cluster2} ${cluster3}; do
  region=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.platformStatus.gcp.region}')
  infrastructureName=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')
  network=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')-network
  subnet=$(oc --context ${cluster} get infrastructure cluster -o jsonpath='{.status.infrastructureName}')-worker-subnet
  port=$(oc --context ${cluster} get service router-default -n openshift-ingress -o json | jq -r '.spec.ports[] | select( .name=="https") | .nodePort')
  for zone in $(gcloud --format json compute zones list --filter region=${region} | jq -r .[].name); do
    gcloud compute network-endpoint-groups create vault-${zone} --network=${network} --subnet=${subnet} --default-port=443  --zone=${zone}
    for instance in $(gcloud --format json compute instances list --zones ${zone} --filter="labels.kubernetes-io-cluster-${infrastructureName}=owned" | jq -r .[].name); do
      gcloud compute network-endpoint-groups update vault-${zone} --zone=${zone} --add-endpoint "instance=${instance},port=${port}"
    done
    gcloud compute backend-services add-backend vault-backend-service --global --network-endpoint-group=vault-${zone} --network-endpoint-group-zone=${zone} --balancing-mode connection --max-connections-per-endpoint 100
  done
done

# create target https proxy
gcloud compute target-tcp-proxies create vault-target-tcp-proxy --backend-service vault-backend-service

# create forwarding rule

gcloud compute forwarding-rules create vault-forwarding-rule --ip-protocol tcp --address vault-global-ipv4 --load-balancing-scheme external --ports 443 --global --target-tcp-proxy vault-target-tcp-proxy --global-address
```

simple multirecord DNS

```shell
IPs=""
for cluster in ${cluster1} ${cluster2} ${cluster3}; do
  IP=$(oc --context ${cluster} get svc router-default -n openshift-ingress -o jsonpath='{.status.loadBalancer.ingress[].ip}')
  echo $IP
  IPs+=${IP},
done
IPs="${IPs%,}"
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export base_domain=${cluster_base_domain#*.}
export global_base_domain=global.${cluster_base_domain#*.}
export global_base_domain_no_dots=$(echo ${global_base_domain} | tr '.' '-')
gcloud dns record-sets create vault.global.demo.gcp.red-chesterfield.com --rrdatas=${IPs} --type=A --ttl=60 --zone=${global_base_domain_no_dots}
```

### Testing vault external connectivity

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath='{.data.root_token}' | base64 -d )
vault status -tls-skip-verify
```

### Access Vault UI

browse to here

```shell
echo $VAULT_ADDR/ui
```

At this point your architecture should look like the below image:

![Vault](./media/Vault.png)

## Vault cert-manager integration

With this integration we enable the previously installed cert-manager to create certificates via vault.

### Prepare Kubernetes authentication

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath='{.data.root_token}'| base64 -d )
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export clusterid=${context}
  vault auth enable -tls-skip-verify -path=kubernetes-${clusterid} kubernetes 
  export sa_secret_name=$(oc --context ${context} get sa vault -n vault -o jsonpath='{.secrets[*].name}' | grep -o '\b\w*\-token-\w*\b')
  export api_url=$(oc --context ${control_cluster} get clusterdeployment ${context} -n ${context} -o jsonpath='{.status.apiURL}')
  oc --context ${context} get secret ${sa_secret_name} -n vault -o jsonpath='{.data.ca\.crt}' | base64 -d > /tmp/ca.crt
  vault write -tls-skip-verify auth/kubernetes-${clusterid}/config token_reviewer_jwt="$(oc --context ${context} serviceaccounts get-token vault -n vault)" kubernetes_host=${api_url} kubernetes_ca_cert=@/tmp/ca.crt
  vault write -tls-skip-verify auth/kubernetes-${clusterid}/role/cert-manager bound_service_account_names=default bound_service_account_namespaces=cert-manager policies=default,cert-manager
done
```

### Prepare vault pki

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath='{.data.root_token}'| base64 -d )
vault secrets enable -tls-skip-verify pki
vault secrets tune -tls-skip-verify -max-lease-ttl=87600h pki
vault write -tls-skip-verify pki/root/generate/internal common_name=cert-manager.cluster.local ttl=87600h
vault write -tls-skip-verify pki/config/urls issuing_certificates="http://vault.vault.svc:8200/v1/pki/ca" crl_distribution_points="http://vault.vault.svc:8200/v1/pki/crl"
vault write -tls-skip-verify pki/roles/cert-manager allowed_domains=svc,svc.cluster.local,svc.clusterset.local,node,root,${global_base_domain},yugabyte,keycloak,vault allow_bare_domains=true allow_subdomains=true allow_localhost=false enforce_hostnames=false
vault policy write -tls-skip-verify cert-manager ./vault/cert-manager-policy.hcl
```

### Prepare cert-manager Cluster Issuer

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export vault_ca=$(oc --context ${context} get secret vault-tls -n vault -o jsonpath='{.data.ca\.crt}')
  export sa_secret_name=$(oc --context ${context} get sa default -n cert-manager -o jsonpath='{.secrets[*].name}' | grep -o '\b\w*\-token-\w*\b')
  export cluster=${context}
  envsubst < ./vault/vault-issuer.yaml | oc --context ${context} apply -f - -n cert-manager
done  
```

## Restart Vault pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} rollout restart statefulset/vault -n vault
done  
```

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} scale statefulset vault -n vault --replicas=0
  oc --context ${context} scale statefulset vault -n vault --replicas=3
done  
```

## Clean up Vault

Use this to clean up vault:

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall vault -n vault
  oc --context ${context} delete pvc data-vault-0 data-vault-1 data-vault-2 -n vault
done  
```
