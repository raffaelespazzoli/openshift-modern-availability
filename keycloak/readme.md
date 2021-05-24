# Keycloack

## Create the keycloak.x image

clone keycloak, switch to the 13.0.0 tag
run this command in the dir ./quarkus/server:

```shell
mvn quarkus:add-extension -Dextensions="vault"
```

build keycloak dist from ./quarkus run:

```shell
mvn -f ../pom.xml clean install -DskipTestsuite -DskipExamples -DskipTests -Pquarkus,distribution
```

build keycloak image

```shell
export keycloak_version=[13.0.0|12.0.4]
docker build -t quay.io/raffaelespazzoli/keycloak.x:${keycloak_version} -f ./Dockerfile.${keycloak_version} ~/git/keycloak
docker login quay.io/raffaelespazzoli/keycloak.x
docker push quay.io/raffaelespazzoli/keycloak.x:${keycloak_version}
```
