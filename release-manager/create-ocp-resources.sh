#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COMPONENT=""
PROJECT=""
BITBUCKET_URL=""
ODS_NAMESPACE=""
ODS_IMAGE_TAG=""
DOCKER_REGISTRY=""

while [[ "$#" > 0 ]]; do case $1 in
  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;

  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  -b=*|--bitbucket=*) BITBUCKET_URL="${1#*=}";;
  -b|--bitbucket) BITBUCKET_URL="$2"; shift;;

  -n=*|--ods-namespace=*) ODS_NAMESPACE="${1#*=}";;
  -n|--ods-namespace) ODS_NAMESPACE="$2"; shift;;

  -i=*|--ods-image-tag=*) ODS_IMAGE_TAG="${1#*=}";;
  -i|--ods-image-tag) ODS_IMAGE_TAG="$2"; shift;;

  -r=*|--docker-registry=*) DOCKER_REGISTRY="${1#*=}";;
  -r|--docker-registry) DOCKER_REGISTRY="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

echo "create docgen service"
cd ${SCRIPT_DIR}/ocp-config

echo "create trigger secret"
SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')

tailor --namespace=${PROJECT}-cd --non-interactive \
  apply \
  --param=COMPONENT=${COMPONENT} \
  --param=PROJECT=${PROJECT} \
  --param=TRIGGER_SECRET=${SECRET} \
  --param=BITBUCKET_URL=${BITBUCKET_URL} \
  --param=REPO_BASE=${BITBUCKET_URL}/scm \
  --param=ODS_NAMESPACE=${ODS_NAMESPACE} \
  --param=ODS_IMAGE_TAG=${ODS_IMAGE_TAG} \
  --param=DOCKER_REGISTRY=${DOCKER_REGISTRY} \
  --selector template=release-manager


