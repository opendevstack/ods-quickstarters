#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while [[ "$#" > 0 ]]; do case $1 in
  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

jiraUrl=$(cat /data/ods-configuration/ods-project-quickstarters/boilerplates/release-manager/jenkins.env | grep JIRA_URL | awk -F "=" '{print $NF}')
nexusUrl=$(cat /data/ods-configuration/ods-project-quickstarters/boilerplates/release-manager/jenkins.env | grep NEXUS_URL | awk -F "=" '{print $NF}')
docgenUrl=$(cat /data/ods-configuration/ods-project-quickstarters/boilerplates/release-manager/jenkins.env | grep DOCGEN_URL | awk -F "=" '{print $NF}')
docgenUrl=$(echo $docgenUrl | sed "s/NAMESPACE/$PROJECT-cd/")

echo "update jenkins master with required environment variables"
oc -n ${PROJECT}-cd set triggers dc/jenkins --from-config --remove
oc -n ${PROJECT}-cd set env dc/jenkins --env=NEXUS_URL=${nexusUrl}
oc -n ${PROJECT}-cd set env dc/jenkins --env=JIRA_URL=${jiraUrl}
oc -n ${PROJECT}-cd set env dc/jenkins --env=DOCGEN_URL=${docgenUrl}
oc -n ${PROJECT}-cd set triggers dc/jenkins --from-config # re-deploys Jenkins

echo "create docgen service"
cd ${SCRIPT_DIR}/../common/ocp-config/cd-docgen

echo "create trigger secret"
SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')

tailor --non-interactive update --namespace=${PROJECT}-cd --param=COMPONENT=${COMPONENT} --param=PROJECT=${PROJECT} --param=TRIGGER_SECRET=${SECRET} --selector app="${PROJECT}-docgen",template=cd-docgen
