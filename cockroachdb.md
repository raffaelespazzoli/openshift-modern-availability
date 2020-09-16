# CockroachDB

In this step we are going to deploy cockroachdb

## Deploy cockroachDB

### Deploy CRDB

this is a good source of info for fixing the crdb helm chart with regards to permissions to the cert files:
https://github.com/kubernetes/kubernetes/issues/34982


```shell
helm repo add cockroachdb https://charts.cockroachdb.com/
helm dependency update ./charts/vault-multicluster
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
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='CREATE USER admin WITH PASSWORD admin;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql --execute='GRANT admin TO admin WITH ADMIN OPTION;' --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local
```

### Connecting to the CRDB ui

```shell
export cluster_base_domain=$(oc --context ${control_cluster} get dns cluster -o jsonpath='{.spec.baseDomain}')
export global_base_domain=global.${cluster_base_domain#*.}
echo cockroachdb.${global_base_domain}
```

connect to $ui_url user admin/admin

At this point your architecture should look like the below image:

![CRDB](./media/CRDB.png)

### Setup Vault to manage CRDB's accounts

```shell
export VAULT_ADDR=https://vault.${global_base_domain}
export VAULT_TOKEN=$(oc --context ${control_cluster} get secret vault-init -n vault -o jsonpath '{data.root_token}'| base64 -d )
vault secrets enable database
vault write database/config/cockroachdb plugin_name=postgresql-database-plugin allowed_roles="cockroachdb-role" connection_url="postgresql://{{username}}:{{password}}@cockroachdb-public.cockroachdb.svc.clusterset.local:5432/" username="admin" password="admin"
vault write database/roles/cockroachdb-role db_name=cockroachdb creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" default_ttl="24h" max_ttl="7d"
```

## clean-up

delete crds

```shell
for context in ${cluster1} ${cluster2} ${cluster3}; do
  helm --kube-context ${context} uninstall cockroachdb -n cockroachdb 
  oc --context ${context} delete pvc datadir-cockroachdb-0 datadir-cockroachdb-1 datadir-cockroachdb-2 -n cockroachdb
done
```
