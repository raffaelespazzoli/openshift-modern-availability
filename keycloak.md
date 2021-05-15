# Keycloak

## Preparing the database

needed because the version of liquidbase used by keycloak is not compatible with cockroachdb

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} rsync -n cockroachdb ./keycloak $tools_pod:/tmp/
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='DROP DATABASE IF EXISTS keycloak CASCADE;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='CREATE DATABASE IF NOT EXISTS keycloak;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
export dump_location=$(oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- cockroach nodelocal upload /tmp/keycloak/keycloak.sql /tmp/keycloak/keycloak.sql --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local | awk '{ print $NF }' )
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute="IMPORT PGDUMP "'"${dump_location}"'" WITH ignore_unsupported_statements;" --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local -d keycloak
```

## Deploy keycloak.x

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export cluster=${context}
  envsubst < ./keycloak/values.templ.yaml > /tmp/values.yaml
  helm --kube-context ${context} upgrade keycloak ./charts/keycloak -i --create-namespace -n keycloak -f /tmp/values.yaml
done
```

log in with admin/admin


## Restart keycloak pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n keycloak
done
```

## Preparing Vault to manage account for the keycloak database

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath='{.data.root_token}'| base64 -d )
vault secrets enable -tls-skip-verify database
vault write -tls-skip-verify database/config/keycloak plugin_name=postgresql-database-plugin allowed_roles="keycloak-role" connection_url="postgresql://{{username}}:{{password}}@cockroachdb-public.cockroachdb.svc.cluster.local:26257/keycloak?sslmode=require" username="dba" password="dba"
vault write -tls-skip-verify database/roles/keycloak-role db_name=keycloak creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT ALL ON DATABASE keycloak TO \"{{name}}\";" default_ttl="24h" max_ttl="7d"
```