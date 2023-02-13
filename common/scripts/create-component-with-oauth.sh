#!/usr/bin/env bash
set -eu

# This script is currently being used for ds-rshiny and ds-jupyter-lab
# components. It sets up the following resource objects:
# * image streams
# * build configs: pipelines
# * build configs: images
# * secrets
# * services
# * routes

# support pointing to patched tailor using TAILOR environment variable
: ${TAILOR:=tailor}

tailor_exe=$(type -P ${TAILOR})
tailor_version=$(${TAILOR} version)

echo "Using tailor ${tailor_version} from ${tailor_exe}"

TAILOR_VERBOSE=""
TAILOR_NON_INTERACTIVE=""

while [[ "$#" -gt 0 ]]; do case $1 in
  -v|--verbose) TAILOR_VERBOSE="-v"; set -x;;

  --non-interactive) TAILOR_NON_INTERACTIVE="--non-interactive";;

  -t=*|--tailor=*) TAILOR="${1#*=}";;
  -t|--tailor) TAILOR="$2"; shift;;

  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project)     PROJECT="$2"; shift;;

  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component)     COMPONENT="$2"; shift;;

   *) echo "Unknown parameter passed: $1"; usage; exit 1;;
esac; shift; done

if [ -z ${PROJECT+x} ]; then
    echo "PROJECT is unset, but required";
    exit 1;
else echo "PROJECT=${PROJECT}"; fi
if [ -z ${COMPONENT+x} ]; then
    echo "COMPONENT is unset, but required";
    exit 1;
else echo "COMPONENT=${COMPONENT}"; fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tailor_apply_in_dir() {
    local dir="$1"; shift
    cd "$dir" && ${TAILOR} ${TAILOR_VERBOSE} ${TAILOR_NON_INTERACTIVE} apply "$@"
}

OCP_CONFIG="${SCRIPT_DIR}/../ocp-config/"
# iterate over different environments
for devenv in dev test ; do
    # create resources
    TAILOR_BASE_ARGS=( \
        "--namespace=${PROJECT}-${devenv}" \
        "--param=PROJECT=${PROJECT}" \
        "--param=COMPONENT=${COMPONENT}" \
        "--param=ENV=${devenv}"
        )

    echo "Creating component ${COMPONENT} in environment ${PROJECT}-${devenv}:"

    tailor_apply_in_dir "${OCP_CONFIG}/component-oauth-sidecar" \
        "${TAILOR_BASE_ARGS[@]}" \
        --selector app="${PROJECT}-${COMPONENT}",template=component-oauth-sidecar

done
