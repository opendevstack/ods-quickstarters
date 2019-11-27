#!/usr/bin/env bash
set -eu

# This script is currently being used for ds-rshiny and ds-jupyter-notebook
# components. It sets up the following resource objects:
# * image streams
# * build configs: pipelines
# * build configs: images
# *·secrets
# * services
# * routes

# support pointing to patched tailor using TAILOR environment variable
: ${TAILOR:=tailor}

tailor_exe=$(type -P ${TAILOR})
tailor_version=$(${TAILOR} version)

echo "Using tailor ${tailor_version} from ${tailor_exe}"

DEBUG=false
STATUS=false
FORCE=false
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--project)
    PROJECT="$2"
    shift # past argument
    ;;
    -c|--component)
    COMPONENT="$2"
    shift # past argument
    ;;
    -nh|--nexushost)
    NEXUS_HOST="$2"
    shift # past argument
    ;;
    -nu|--nexususername)
    NEXUS_USERNAME="$2"
    shift # past argument
    ;;
    -np|--nexuspassword)
    NEXUS_PASSWORD="$2"
    shift # past argument
    ;;
    --status)
    STATUS=true
    ;;
    --force)
    FORCE=true
    ;;
    -d|--debug)
    DEBUG=true;
    ;;
    *)
    echo "Unknown option: $1. Exiting."
    exit 1
    ;;
esac
shift # past argument or value
done

if $DEBUG; then
  tailor_verbose="-v"
else
  tailor_verbose=""
fi

if $FORCE; then
  tailor_verbose+=" --force"
fi

if [ -z ${PROJECT+x} ]; then
    echo "PROJECT is unset, but required";
    exit 1;
else echo "PROJECT=${PROJECT}"; fi
if [ -z ${COMPONENT+x} ]; then
    echo "COMPONENT is unset, but required";
    exit 1;
else echo "COMPONENT=${COMPONENT}"; fi
if [ -z ${NEXUS_HOST+x} ]; then
    echo "NEXUS_HOST is unset, but required";
    exit 1;
else echo "NEXUS_HOST=${NEXUS_HOST}"; fi
if [ -z ${NEXUS_USERNAME+x} ]; then
    echo "NEXUS_USERNAME is unset, but required";
    exit 1;
else echo "NEXUS_USERNAME=${NEXUS_USERNAME}"; fi
if [ -z ${NEXUS_PASSWORD+x} ]; then
    echo "NEXUS_PASSWORD is unset, but required";
    exit 1;
fi
echo "Params: ${tailor_verbose}"

if $STATUS; then
  echo "NOTE:Invoked with --status:  will use tailor status instead of tailor update."
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tailor_update_in_dir() {
    local dir="$1"; shift
    if [ ${STATUS} = "true" ]; then
        $DEBUG && echo 'exec:' cd  "$dir" '&&'
        $DEBUG && echo 'exec:'     ${TAILOR} $tailor_verbose status "$@"
        cd "$dir" && ${TAILOR} $tailor_verbose status "$@"
    else
        $DEBUG && echo 'exec:' cd "$dir" '&&'
        $DEBUG && echo 'exec:    ' ${TAILOR} $tailor_verbose --non-interactive update "$@"
        cd "$dir" && ${TAILOR} $tailor_verbose --non-interactive update "$@"
    fi
}

OCP_CONFIG="${SCRIPT_DIR}/../ocp-config/"
# iterate over different environments
for devenv in dev test ; do
    # create resources
    TAILOR_BASE_ARGS=( \
        "--namespace=${PROJECT}-${devenv}" \
        "--param=PROJECT=${PROJECT}" \
        "--param=COMPONENT=${COMPONENT}" \
        "--param=ENV=${devenv}" \
        "--param=NEXUS_HOST=${NEXUS_HOST}" \
        "--param=NEXUS_USERNAME=${NEXUS_USERNAME}" \
        "--param=NEXUS_PASSWORD=${NEXUS_PASSWORD}"
        )

    echo "Creating component ${COMPONENT} in environment ${PROJECT}-${devenv}:"

    tailor_update_in_dir "${OCP_CONFIG}/ds-component-environment" \
        "${TAILOR_BASE_ARGS[@]}" \
        secret/nexus

    tailor_update_in_dir "${OCP_CONFIG}/ds-component-environment" \
        "${TAILOR_BASE_ARGS[@]}" \
        --selector "app=${PROJECT}-${COMPONENT},template=ds-component"

    tailor_update_in_dir "${OCP_CONFIG}/ds-component-environment" \
        "${TAILOR_BASE_ARGS[@]}" \
        --selector "app=${PROJECT}-${COMPONENT},template=ds-component-oauthproxy"

done
