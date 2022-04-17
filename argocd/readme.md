# Modern availability via Argocd

This document explains how to setup the modern availability demo via argocd

Deploy the argocd operator

## Deploy the gitops operator

```shell
oc apply -f ./argocd/operator.yaml
oc apply -f ./argocd/rbac.yaml
# wait a couple of minutes...
oc apply -f ./argocd/argocd.yaml
oc apply -f ./argocd/argo-root-application.yaml
```

## Deploy the clusters

There is probably a better way to automate this step

```shell
export ssh_key=$(cat ~/.ssh/ocp_rsa | sed 's/^/          /')
export ssh_pub_key=$(cat ~/.ssh/ocp_rsa.pub)
export pull_secret=$(cat ~/git/openshift-enablement-exam/4.0/pullsecret.json)
export base_domain=$(oc get dns cluster -o jsonpath='{.spec.baseDomain}')
export base_domain=${base_domain#*.}
export cluster_release_image=quay.io/openshift-release-dev/ocp-release:$(oc get clusteroperator config-operator -o jsonpath='{.status.versions[0].version}')-x86_64

# allowed values are aws,azure,gcp, by default same as control cluster
export infrastructure=$(oc get infrastructure cluster -o jsonpath='{.spec.platformSpec.type}'| tr '[:upper:]' '[:lower:]')
#aws
export aws_id=$(cat ~/.aws/credentials | grep aws_access_key_id | cut -d'=' -f 2)
export aws_key=$(cat ~/.aws/credentials | grep aws_secret_access_key | cut -d'=' -f 2)
#gcp
export gcp_sa_json=$(cat ~/.gcp/osServiceAccount.json | sed 's/^/            /')
export gcp_project_id=$(cat ~/.gcp/osServiceAccount.json | jq -r .project_id)
#azr
export base_domain_resource_group_name=$(oc get DNS cluster -o jsonpath='{.spec.publicZone.id}' | cut -f 5 -d "/" -)
export azr_sa_json=$(cat ~/.azure/osServicePrincipal.json)

case ${infrastructure} in
  aws)
    export region="us-east-1"
  ;;
  gcp)
    export region="us-east4"
  ;;
  azure)
    export region="eastus2"
  ;;
esac  
export network_cidr="10.128.0.0/14"
export service_cidr="172.30.0.0/16"
export node_cidr="10.0.0.0/16"

cluster=cluster1 envsubst < ./argocd/ocp-cluster-app-template.yaml | oc apply -f -

case ${infrastructure} in
  aws)
    export region="us-east-2"
  ;;
  gcp)
    export region="us-central1"
  ;;
  azure)
    export region="centralus"
  ;;
esac
export network_cidr="10.132.0.0/14"
export service_cidr="172.31.0.0/16"
export node_cidr="10.1.0.0/16"

cluster=cluster2 envsubst < ocp-cluster-app-template.yaml | oc apply -f -

case ${infrastructure} in
  aws)
    export region="us-west-2"
  ;;
  gcp)
    export region="us-west1"
  ;;
  azure)
    export region="westus2"
  ;;
esac
export network_cidr="10.136.0.0/14"
export service_cidr="172.32.0.0/16"
export node_cidr="10.2.0.0/16"

cluster=cluster3 envsubst < ocp-cluster-app-template.yaml | oc apply -f -
```