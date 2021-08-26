# Create a global change data capture deployment

This guide assumes that you have already deployed Cockroachdb and Kafka

## Configurations on CockroachDB

Enable rangefeeds

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="SET CLUSTER SETTING kv.rangefeed.enabled = true;"
```

create changefeed for all tables in the tpcc database

```shell
export tools_pod=$(oc --context ${cluster1} get pods -n cockroachdb | grep tools | awk '{print $1}')
export CA_CERT=$(oc --context ${cluster1} get secret -n cockroachdb cockroachdb-tls -o jsonpath='{.data.ca\.crt}')
oc --context ${cluster1} exec $tools_pod -c tools -n cockroachdb -- /cockroach/cockroach sql  --certs-dir=/crdb-certs --host cockroachdb-0.cluster1.cockroachdb.cockroachdb.svc.clusterset.local --echo-sql --execute="CREATE CHANGEFEED FOR TABLE tpcc.public.warehouse INTO 'kafka://kafka.kafka.svc.cluster.local:9093?tls_enabled=true&ca_cert=${CA_CERT}' WITH UPDATED, compression=gzip, full_table_name;"
```
