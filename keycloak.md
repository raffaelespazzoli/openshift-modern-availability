# Keycloak

## Preparing the database

needed because the version of liquidbase used by keycloak is not compatible with cockroachdb

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} rsync -n cockroachdb ./keycloak $tools_pod:/tmp/
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='DROP DATABASE IF EXISTS keycloak CASCADE;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='CREATE DATABASE IF NOT EXISTS keycloak;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
export dump_location=$(oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- cockroach nodelocal upload /tmp/keycloak/keycloak-13.0.0.sql /tmp/keycloak/keycloak-13.0.0.sql --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local | awk '{ print $NF }' )
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='IMPORT PGDUMP "'""${dump_location}""'" WITH ignore_unsupported_statements;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local -d keycloak
```

## Preparing Vault to manage account for the keycloak database

this does not work with the current version of keycloak, but these below are the right steps, once keycloak gets fixed.

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath='{.data.root_token}'| base64 -d )
vault secrets enable -tls-skip-verify database
vault write -tls-skip-verify database/config/keycloak plugin_name=postgresql-database-plugin allowed_roles="keycloak-role" connection_url="postgresql://{{username}}:{{password}}@cockroachdb-public.cockroachdb.svc.cluster.local:26257/keycloak?sslmode=require&sslrootcert=/global-certs/tls.ca" username="dba" password="dba" username_template="keycloak-{{ random 20 | lowercase }}-{{ unix_time }}"
vault write -tls-skip-verify database/roles/keycloak-role db_name=keycloak creation_statements=@./keycloak/creation-statement.sql default_ttl="1h" max_ttl="24h" revocation_statements="ALTER ROLE \"{{name}}\" NOLOGIN;" renew_statements="ALTER ROLE \"{{name}}\" VALID UNTIL '{{expiration}}';"
vault policy write -tls-skip-verify keycloak-role-policy ./keycloak/keycloak-policy.hcl
for context in ${cluster1} ${cluster2} ${cluster3}; do
  vault write -tls-skip-verify auth/kubernetes-${context}/role/keycloak bound_service_account_names=default bound_service_account_namespaces=keycloak policies=default,keycloak-role-policy
done
#test
export sa_token=$(oc --context cluster1 serviceaccounts get-token default -n keycloak)
export client_token=$(vault write -tls-skip-verify auth/kubernetes-cluster1/login role=keycloak jwt=${sa_token} -format=json | jq -r '.auth.client_token')
VAULT_TOKEN=${client_token} vault read -tls-skip-verify database/creds/keycloak-role
```

## Deploy keycloak.x

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  export vault_ca=$(oc --context ${context} get secret vault-tls -n vault -o jsonpath='{.data.ca\.crt}')
  envsubst < ./keycloak/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade keycloak ./charts/keycloak -i --create-namespace -n keycloak -f /tmp/values.yaml
done
```

log in with admin/admin

## Configure OpenShift Authentication

Configure Keycloak to support OpenShift authentication

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/bin/kcadm.sh config credentials --server https://keycloak.${global_base_domain} --realm master --user admin --password admin --config /tmp/kcadm.config --truststore /certs/truststore.jks --trustpass changeit
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/bin/kcadm.sh create realms --config /tmp/kcadm.config --truststore /certs/truststore.jks --trustpass changeit -s realm=global-openshift -s enabled=true
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export base_ingress_url=$(oc --context ${context} get ingress.config.openshift.io cluster -o jsonpath='{.spec.domain}')
  oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/bin/kcadm.sh create clients --config /tmp/kcadm.config --truststore /certs/truststore.jks --trustpass changeit -r global-openshift -s clientId=${context} -s enabled=true -s secret=ciao -s 'redirectUris=["https://oauth-openshift.'${base_ingress_url}'/oauth2callback/global-keycloak"]'
done
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/bin/kcadm.sh create users --config /tmp/kcadm.config --truststore /certs/truststore.jks --trustpass changeit -r global-openshift -s username=raffa -s enabled=true
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/bin/kcadm.sh set-password --config /tmp/kcadm.config --truststore /certs/truststore.jks --trustpass changeit -r global-openshift --username raffa --new-password raffa
```

Configure OCP clusters for keycloak authentication

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export keycloak_fqdn=keycloak.${global_base_domain}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  oc --context ${context} get secret -n keycloak keycloak-route-tls -o jsonpath='{.data.ca\.crt}' | base64 -d > /tmp/ca.crt
  oc --context ${context} create configmap ocp-ca-bundle --from-file=/tmp/ca.crt -n openshift-config
  oc --context ${context} apply -f ./keycloak/oidc-secret.yaml -n openshift-config
  export oauth_patch=$(cat ./keycloak/oauth-patch.yaml | envsubst | yq .)
  oc --context ${context} patch OAuth.config.openshift.io cluster -p '[{"op": "add", "path": "/spec", "value": '"${oauth_patch}"' }]' --type json
  oc --context ${context} adm policy add-cluster-role-to-user cluster-admin raffa
done
```

## Simulate a disaster

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

## Restart keycloak pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n keycloak
done
```

## Rescale keycloak pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} scale statefulset keycloak -n keycloak --replicas=0
 oc --context ${context} scale statefulset keycloak -n keycloak --replicas=2
done
```

## Uninstall keycloak

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall keycloak -n keycloak 
done
```

<!--

## Troubleshooting issue with vault

needed because the version of liquidbase used by keycloak is not compatible with cockroachdb

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} rsync -n cockroachdb ./keycloak $tools_pod:/tmp/
for version in "12.0.4" "13.0.0"; do
  export version_no_dots="${version//./}"
  oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute="DROP DATABASE IF EXISTS keycloak${version_no_dots} CASCADE;" --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
  oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute="CREATE DATABASE IF NOT EXISTS keycloak${version_no_dots};" --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
  export dump_location=$(oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- cockroach nodelocal upload /tmp/keycloak/keycloak-${version}.sql /tmp/keycloak/keycloak-${version}.sql --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local | awk '{ print $NF }' )
  oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='IMPORT PGDUMP "'""${dump_location}""'" WITH ignore_unsupported_statements;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local -d keycloak${version_no_dots}
done  
```

## Preparing Vault to manage account for the keycloak database

this does not work with the current version of keycloak, but these below are the right steps, once keycloak gets fixed.

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath='{.data.root_token}'| base64 -d )
vault secrets enable -tls-skip-verify database
for version in "12.0.4" "13.0.0"; do
  export version_no_dots="${version//./}"
  vault write -tls-skip-verify database/config/keycloak-${version} plugin_name=postgresql-database-plugin allowed_roles="keycloak-role-${version}" connection_url="postgresql://{{username}}:{{password}}@cockroachdb-public.cockroachdb.svc.cluster.local:26257/keycloak${version_no_dots}?sslmode=require&sslrootcert=/global-certs/tls.ca" username="dba" password="dba" username_template="keycloak-{{ random 20 | lowercase }}-{{ unix_time }}"
  version_no_dots=${version_no_dots} envsubst < ./keycloak/creation-statement.sql > /tmp/creation-statement.sql
  vault write -tls-skip-verify database/roles/keycloak-role-${version} db_name=keycloak-${version} creation_statements=@/tmp/creation-statement.sql default_ttl="1h" max_ttl="24h" revocation_statements="ALTER ROLE \"{{name}}\" NOLOGIN;" renew_statements="ALTER ROLE \"{{name}}\" VALID UNTIL '{{expiration}}';"
  version=${version} envsubst < ./keycloak/keycloak-policy.hcl > /tmp/keycloak-policy.hcl
  vault policy write -tls-skip-verify keycloak-role-policy-${version} /tmp/keycloak-policy.hcl
  for context in ${cluster1} ${cluster2} ${cluster3}; do
    vault write -tls-skip-verify auth/kubernetes-${context}/role/keycloak-${version} bound_service_account_names=default bound_service_account_namespaces=keycloak-${version_no_dots},keycloak policies=default,keycloak-role-policy-${version}
  done
  #test
  oc --context cluster1 new-project keycloak-${version_no_dots}
  export sa_token=$(oc --context cluster1 serviceaccounts get-token default -n keycloak-${version_no_dots})
  export client_token=$(vault write -tls-skip-verify auth/kubernetes-cluster1/login role=keycloak-${version} jwt=${sa_token} -format=json | jq -r '.auth.client_token')
  VAULT_TOKEN=${client_token} vault read -tls-skip-verify database/creds/keycloak-role-${version}
done
```

## Deploy keycloak.x

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export version="13.0.0"
export version_no_dots="${version//./}"
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  export vault_ca=$(oc --context ${context} get secret vault-tls -n vault -o jsonpath='{.data.ca\.crt}')
  envsubst < ./keycloak/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade keycloak ./charts/keycloak -i --create-namespace -n keycloak -f /tmp/values.yaml
done
```
-->
