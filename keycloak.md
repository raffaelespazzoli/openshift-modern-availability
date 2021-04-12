# Keycloak

## Preparing the database

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='CREATE DATABASE keycloak;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='CREATE ROLE keycloak LOGIN PASSWORD keycloak;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='GRANT ALL ON DATABASE keycloak TO keycloak' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
```

## RH-SSO Installation

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
export keycloak_username=keycloak
export keycloak_password=keycloak
for context in ${cluster1} ${cluster2} ${cluster3}; do
  oc --context ${context} new-project rhsso
  oc --context ${context} apply -f ./keycloak/operator.yaml -n rhsso
  envsubst < ./keycloak/keycloak.yaml | oc --context ${context} apply -f - -n rhsso
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


## keycloak.X

Install openshift pipelines

```shell
oc apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/maven/0.2/maven.yaml
oc new-project keycloak
oc apply -f ./keycloak/keycloak-quarkus-pipeline.yaml -n keycloak
oc apply -f ./keycloak/keycloak-statefulset.yaml -n keycloak
```