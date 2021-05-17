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

## Configure OpenShift Authentication

configure Keycloak to support OpenShift authentication

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
curl -L --output /tmp/keycloakmigration-0.2.18-fat.jar https://github.com/mayope/keycloakmigration/releases/download/0.2.18/keycloakmigration-0.2.18-fat.jar
java -jar /tmp/keycloakmigration-0.2.18-fat.jar -b https://keycloak.${global_base_domain} ./keycloak/configuration/01_realm.yaml
java -jar /tmp/keycloakmigration-0.2.18-fat.jar -b https://keycloak.${global_base_domain} ./keycloak/configuration/02_client/yaml
java -jar /tmp/keycloakmigration-0.2.18-fat.jar -b https://keycloak.${global_base_domain} ./keycloak/configuration/03_user/yaml
```

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/keycloak.x-12.0.4/bin/kcadm.sh config credentials --server https://keycloak.${global_base_domain}/auth --realm master --user admin --password admin --config /tmp/kcadm.config --truststore /certs/truststore.jks --trustpass changeit
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/keycloak.x-12.0.4/bin/kcadm.sh create realms --config /tmp/kcadm.config  -s realm=global-openshift -s enabled=true
for context in ${cluster1} ${cluster2} ${cluster3}; do
  export base_ingress_url=oc --context ${context} get ingress cluster -o jsonpath='{.spec.domain}'
  oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/keycloak.x-12.0.4/bin/kcadm.sh create clients --config /tmp/kcadm.config -r global-openshift -s clientId=cluster1 -s enabled=true -s secret=ciao -s redirectUris=["https://oauth-openshift.apps.${base_ingress_url}/oauth2callback"] -s standardFlowEnabled=true -s implicitFlowEnabled=false -s directAccessGrantEnabled=true
done
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/keycloak.x-12.0.4/bin/kcadm.sh create users --config /tmp/kcadm.config -r global-openshift -s username=raffa -s enabled=true
oc --context ${cluster1} exec -n keycloak keycloak-0 -- /opt/keycloak/keycloak.x-12.0.4/bin/kcadm.sh set-password --config /tmp/kcadm.config -r global-openshift --username raffa --new-password raffa
```

configure OCP clusters for keycloak authentication

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
  oc --context ${context} patch OAuth.config.openshift.io cluster -p '[{"op": "add", "path": "/spec/identityProviders/-", "value": '"${oauth_patch}"' }]' --type json
done
```

## Restart keycloak pods

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
 oc --context ${context} rollout restart statefulset -n keycloak
done
```

## Uninstall keycloak

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall keycloak -n keycloak 
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