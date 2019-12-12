#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while [[ "$#" > 0 ]]; do case $1 in
  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;
  -b=*|--bitbucket=*) BITBUCKET_URL="${1#*=}";;
  -b|--bitbucket) BITBUCKET_URL="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

echo "update jenkins master with required environment variable"
oc -n ${PROJECT}-cd set triggers dc/jenkins --from-config --remove
oc -n ${PROJECT}-cd set env dc/jenkins --env=DOCGEN_URL=http://docgen.${PROJECT}-cd.svc:8080
oc -n ${PROJECT}-cd set triggers dc/jenkins --from-config # re-deploys Jenkins

echo "create docgen service"
cd ${SCRIPT_DIR}/ocp-config

echo "create trigger secret"
SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')

tailor --namespace=${PROJECT}-cd --non-interactive --force \
  update \
  --param=COMPONENT=${COMPONENT} \
  --param=PROJECT=${PROJECT} \
  --param=TRIGGER_SECRET=${SECRET} \
  --param=BITBUCKET_URL=${BITBUCKET_URL} \
  --param=REPO_BASE=${BITBUCKET_URL}/scm \
  --selector app="${PROJECT}-docgen",template=cd-docgen


