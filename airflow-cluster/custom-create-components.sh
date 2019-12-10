#!/usr/bin/env bash

# This script sets up the resource objects for a certain component:
# * image streams
# * build configs: pipelines
# * build configs: images
# * services
# * environment variables

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -p|--project)
    PROJECT="$2"
    shift # past argument
    ;;
    -b|--bitbucket)
    BITBUCKET_REPO="$2"
    shift # past argument
    ;;
    -gr|--gitref)
    ODS_GIT_REF="$2"
    shift # past argument
    ;;
    -oc|--oc-console)
    OC_CONSOLE_URL="$2"
    shift # past argument
    ;;
    -oa|--oc-api)
    OC_API_URL="$2"
    shift # past argument
    ;;
    -r|--docker-registry)
    OC_DOCKER_REGISTRY="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ -z ${PROJECT+x} ]; then
    echo "PROJECT is unset, but required";
    exit 1;
else echo "PROJECT=${PROJECT}"; fi
if [ -z ${OC_API_URL+x} ]; then
    echo "OC_API_URL is unset, but required";
    exit 1;
else echo "OC_API_URL=${OC_API_URL}"; fi
if [ -z ${OC_CONSOLE_URL+x} ]; then
    echo "OC_CONSOLE_URL is unset, but required";
    exit 1;
else echo "OC_CONSOLE_URL=${OC_CONSOLE_URL}"; fi
if [ -z ${OC_DOCKER_REGISTRY+x} ]; then
    echo "OC_DOCKER_REGISTRY is unset, but required";
    exit 1;
else echo "OC_DOCKER_REGISTRY=${OC_DOCKER_REGISTRY}"; fi
if [ -z ${BITBUCKET_REPO+x} ]; then
    echo "BITBUCKET_REPO is unset, but required";
    exit 1;
else echo "BITBUCKET_REPO=${BITBUCKET_REPO}"; fi
if [ -z ${ODS_GIT_REF+x} ]; then
    echo "ODS_GIT_REF is unset, but required";
    exit 1;
else echo "ODS_GIT_REF=${ODS_GIT_REF}"; fi
environments=(test dev)
# iterate over different environments
echo "--------------"
oc version
echo "--------------"

echo "creating airflow base images"
oc process -f templates/base-images.yaml \
    PROJECT_ID=${PROJECT} \
    ODS_GIT_REF=${ODS_GIT_REF} \
    REPO_BASE=${BITBUCKET_REPO} | oc create -n ${PROJECT}-cd -f -

oc start-build airflow -n ${PROJECT}-cd --follow
oc start-build elasticsearch -n ${PROJECT}-cd --follow

echo "creating airflow cluster"
for ENV in ${environments[@]} ; do

    RESOURCES=$(oc get dc,bc,svc,secret,pvc,route,sa,rolebinding,cm,is -l cluster=airflow --ignore-not-found -n ${PROJECT}-${ENV})

    if [[ ! -z ${RESOURCES} ]]; then
        echo "Environemnt ${PROJECT}-${ENV} has airflow resources:"
        echo ""
        echo "$RESOURCES"
        echo ""
        echo ""
        echo "To clean all resources, the command:"
        echo "      oc delete dc,bc,svc,secret,pvc,route,sa,rolebinding,cm,is -l cluster=airflow  -n ${PROJECT}-${ENV} && oc delete rolebinding airflow-admin-binding  -n ${PROJECT}-${ENV}"
        echo "can be used."
        echo ""
        echo "Skipping..."
        continue
    fi

    FERNET_KEY=$(dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64)

    # Creating service account and bindings
    oc create -f templates/service-account.yaml -n ${PROJECT}-${ENV}
    oc create rolebinding airflow-admin-binding --serviceaccount ${PROJECT}-${ENV}:airflow --clusterrole admin -n ${PROJECT}-${ENV}

    # Creating PostgreSQL resources
    oc process -f templates/postgresql-persistent.yaml | oc create -n ${PROJECT}-${ENV} -f -

    # Creating ElasticSearch resources
    oc process -f templates/elasticsearch/elasticsearch-persistent-master-template.yaml \
        PROJECT_ID=${PROJECT} \
        COMPONENT_NAME=airflow-elasticsearch \
        CLUSTER_NAME=airflow \
        NAMESPACE=${PROJECT}-${ENV} \
        VOLUME_SIZE_IN_GI=1 | oc create -n ${PROJECT}-${ENV} -f -

    SA_TOKEN=$(oc describe sa airflow -n ${PROJECT}-${ENV} | grep "Tokens:" | cut -d':' -f2 | tr -d '[:space:]')

    # Create Airflow resources
    oc process -f templates/airflow.yaml \
        PROJECT_ID=${PROJECT} \
        OC_API_URL=${OC_API_URL} \
        OC_CONSOLE_URL=${OC_CONSOLE_URL} \
        OC_DOCKER_REGISTRY=${OC_DOCKER_REGISTRY} \
        AIRFLOW_FERNET_KEY=${FERNET_KEY} \
        OPENSHIFT_OAUTH_SERVICE_ACCOUNT_SECRET=${SA_TOKEN} \
        NAMESPACE=${PROJECT}-${ENV} | oc create -n ${PROJECT}-${ENV} -f -

done
