#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR is $SCRIPT_DIR"
ODS_CONFIGURATION_DIR=../../../../ods-configuration

echo_done(){
    echo -e "\033[92mDONE\033[39m: $1"
}

echo_warn(){
    echo -e "\033[93mWARN\033[39m: $1"
}

echo_error(){
    echo -e "\033[31mERROR\033[39m: $1"
}

echo_info(){
    echo -e "\033[94mINFO\033[39m: $1"
}

BITBUCKET_URL=""
BITBUCKET_USER=""
BITBUCKET_PWD=""
BITBUCKET_PROJECT="unitt"
INSECURE=""
REPOSITORY=

function usage {
    printf "Initialise a Bitbucket project including passed repositories.\n\n"
    printf "This script will ask interactively for parameters by default.\n"
    printf "However, you can also pass them directly. Usage:\n\n"
    printf "\t-h|--help\t\tPrint usage\n"
    printf "\t-v|--verbose\t\tEnable verbose mode\n"
    printf "\t-i|--insecure\t\tAllow insecure server connections when using SSL\n"
    printf "\n"
    printf "\t-b|--bitbucket\t\tBitbucket URL, e.g. 'https://bitbucket.example.com'\n"
    printf "\t-u|--user\t\tBitbucket user\n"
    printf "\t-p|--password\t\tBitbucket password\n"
    printf "\t-t|--project\tName of bitbucket project (defaults to '%s')\n" "${BITBUCKET_PROJECT}"
}

while [[ "$#" -gt 0 ]]; do
    case $1 in

    -v|--verbose) set -x;;

    -h|--help) usage; exit 0;;

    -i|--insecure) INSECURE="--insecure";;

    -b|--bitbucket) BITBUCKET_URL="$2"; shift;;
    -b=*|--bitbucket=*) BITBUCKET_URL="${1#*=}";;

    -u|--user) BITBUCKET_USER="$2"; shift;;
    -u=*|--user=*) BITBUCKET_USER="${1#*=}";;

    -p|--password) BITBUCKET_PWD="$2"; shift;;
    -p=*|--password=*) BITBUCKET_PWD="${1#*=}";;

    -t|--project) BITBUCKET_PROJECT="$2"; shift;;
    -t=*|--project=*) BITBUCKET_PROJECT="${1#*=}";;

    -r|--repository) REPOSITORY="$2"; shift;;
    -r=*|--repository=*) REPOSITORY="${1#*=}";;


  *) echo_error "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

if [ -z "${BITBUCKET_URL}" ]; then
    configuredUrl="https://bitbucket.example.com"
    if [ -f "${ODS_CONFIGURATION_DIR}/ods-core.env" ]; then
        echo_info "Configuration located"
        configuredUrl=$(grep BITBUCKET_URL "${ODS_CONFIGURATION_DIR}/ods-core.env" | cut -d "=" -f 2-)
    fi
    read -r -e -p "Enter Bitbucket URL [${configuredUrl}]: " input
    if [ -z "${input}" ]; then
        BITBUCKET_URL=${configuredUrl}
    else
        BITBUCKET_URL="${input}"
    fi
fi

if [ -z "${BITBUCKET_USER}" ]; then
    read -r -e -p "Enter Bitbucket user on ${BITBUCKET_URL}: " input
    BITBUCKET_USER="${input}"
fi

if [ -z "${BITBUCKET_PWD}" ]; then
    read -r -e -p "Enter Bitbucket password for user '${BITBUCKET_USER}': " input
    BITBUCKET_PWD="${input}"
fi

# Create bitbucket project if it does not exist yet
httpCode=$(curl ${INSECURE} -sS -o /dev/null -w "%{http_code}" \
    --user "${BITBUCKET_USER}:${BITBUCKET_PWD}" \
    "${BITBUCKET_URL}/rest/api/1.0/projects/${BITBUCKET_PROJECT}")
if [ "${httpCode}" == "404" ]; then
    echo_info "Creating project ${BITBUCKET_PROJECT} in Bitbucket"
    httpCodeCreate=$(curl ${INSECURE} -sS -o /dev/null -w "%{http_code}" -X POST \
        --user "${BITBUCKET_USER}:${BITBUCKET_PWD}" \
        -H "Content-Type: application/json" \
        -d "{\"key\":\"${BITBUCKET_PROJECT}\", \"name\": \"${BITBUCKET_PROJECT}\", \"description\": \"testproject\"}" \
        "${BITBUCKET_URL}/rest/api/1.0/projects")
    if [[ "${httpCodeCreate}" != "409" && "${httpCodeCreate}" != "201" ]]; then
    	echo_error "Could not create bitbucket project ${BITBUCKET_PROJECT}, error: ${httpCodeCreate}"
    	exit 1
    fi
elif [ "${httpCode}" == "200" ]; then
    echo_info "Found project ${BITBUCKET_PROJECT} in Bitbucket."
else
    echo_error "Could not determine state of project ${BITBUCKET_PROJECT} on Bitbucket, got ${httpCode}."
    exit 1
fi

# For each of the listed names, a repository will be created in the local bitbucket
# instance under the OPENDEVSTACK project. The list should be synced with the repo
# list in ods-core/ods-setup/repos.sh.
repository=${REPOSITORY:-"docker-plain-test"}
httpCode=$(curl ${INSECURE} -sS -o /dev/null -w "%{http_code}" \
    --user "${BITBUCKET_USER}:${BITBUCKET_PWD}" \
    "${BITBUCKET_URL}/rest/api/1.0/projects/${BITBUCKET_PROJECT}/repos/${repository}")
if [ "${httpCode}" == "200" ]; then
    echo "Found repository, will delete it"
    curl ${INSECURE} -X DELETE --user "${BITBUCKET_USER}:${BITBUCKET_PWD}" "${BITBUCKET_URL}/rest/api/1.0/projects/${BITBUCKET_PROJECT}/repos/${repository}"
fi
echo_info "Creating repository ${BITBUCKET_PROJECT}/${repository} on Bitbucket."
curl ${INSECURE} -sSf -X POST \
    --user "${BITBUCKET_USER}:${BITBUCKET_PWD}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${repository}\", \"scmId\": \"git\", \"forkable\": true}" \
    "${BITBUCKET_URL}/rest/api/1.0/projects/${BITBUCKET_PROJECT}/repos"

echo_done "Bitbucket project ${BITBUCKET_PROJECT} configured"
