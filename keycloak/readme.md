# Keycloack

## Create the keycloak.x image

```shell
docker build -t quay.io/raffaelespazzoli/keycloak.x:12.0.4 .
docker login quay.io/raffaelespazzoli/keycloak.x
docker push quay.io/raffaelespazzoli/keycloak.x:12.0.4
```