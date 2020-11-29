# Keycloack

## Create keycloak quarkus image

```shell
export namespace=keycloak-quarkus
oc new-project ${namespace}
oc create secret docker-registry quay-creds --docker-server=quay.io --docker-username=raffaelespazzoli --docker-password=xxx --docker-email=raffaelespazzoli@gmail.com -n ${namespace}
oc secrets link pipeline quay-creds --for=pull,mount -n ${namespace}
oc apply -f ./keycloak/keycloak-quarkus-pipeline.yaml -n ${namespace}
```