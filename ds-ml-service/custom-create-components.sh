#!/usr/bin/env bash
set -eux

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

# support pointing to patched tailor using TAILOR environment variable
: ${TAILOR:=tailor}

tailor_exe=$(type -P ${TAILOR})
tailor_version=$(${TAILOR} version)

echo "Using tailor ${tailor_version} from ${tailor_exe}"

DEBUG=false
STATUS=false

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
    -b|--bitbucket)
    BITBUCKET_REPO="$2"
    shift # past argument
    ;;
    -ne|--nexus)
    NEXUS_HOST="$2"
    shift # past argument
    ;;
    --status)
    STATUS=true
    ;;
    -d|--debug)
    DEBUG=true;
    ;;
    *)
    echo "Unknown option: $1. Exiting."
    exit 1
esac
shift # past argument or value
done

if $DEBUG; then
  tailor_verbose="-v"
else
  tailor_verbose=""
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

if $STATUS; then
  echo "NOTE:Invoked with --status:  will use tailor status instead of tailor update."
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tailor_update_in_dir() {
    local dir="$1"; shift
    if [ ${STATUS} = "true" ]; then
        $DEBUG && echo 'exec:' cd  "$dir" '&&'
        $DEBUG && echo 'exec:'     ${TAILOR} $tailor_verbose status "$@"
        set +e  # tailor exits with negative if diffs are found but we want to simply preview them
        cd "$dir" && ${TAILOR} $tailor_verbose status "$@"
        set -e
    else
        $DEBUG && echo 'exec:' cd "$dir" '&&'
        $DEBUG && echo 'exec:    ' ${TAILOR} $tailor_verbose --non-interactive update "$@"
        cd "$dir" && ${TAILOR} $tailor_verbose --non-interactive update "$@"
    fi
}

OCP_CONFIG="${SCRIPT_DIR}/../ocp-config/"

# iterate over different environments
for devenv in dev test ; do
    for type in training-service prediction-service ; do
        # create resources
        TAILOR_BASE_ARGS=( \
            "--namespace=${PROJECT}-${devenv}" \
            "--param=PROJECT=${PROJECT}" \
            "--param=COMPONENT=${COMPONENT}-${type}" \
            "--param=ENV=${devenv}"
            )

        echo "${PROJECT} -- ${COMPONENT}-${type} -- ${BITBUCKET_REPO}"
        tailor_update_in_dir "${OCP_CONFIG}/component-environment" \
            "${TAILOR_BASE_ARGS[@]}" \
            --selector app="${PROJECT}-${COMPONENT}-${type}",template=component-template
        # create component environment variables
        echo "--> setting environment variables for component type ${type} in env ${devenv}";
        if [ ${type} = "training-service" ]; then
            set +x # avoid disclosure of passwords/tokens
            echo creating secret ${COMPONENT}-training-secret
            oc create secret generic ${COMPONENT}-training-secret --from-literal=username=${COMPONENT}-training-username --from-literal=password=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64  | rev | cut -b 2- | rev | tr -cd '[:alnum:]'` -n ${PROJECT}-${devenv}
            set -x
            oc set triggers dc/${COMPONENT}-${type} --from-config --remove -n ${PROJECT}-${devenv}
            oc set env dc/${COMPONENT}-${type} --env=DSI_EXECUTE_ON=LOCAL -n ${PROJECT}-${devenv}
            oc set env dc/${COMPONENT}-${type} --from=secret/${COMPONENT}-training-secret --prefix=DSI_TRAINING_SERVICE_ -n ${PROJECT}-${devenv}
            oc set triggers dc/${COMPONENT}-${type} --from-config -n ${PROJECT}-${devenv}
        else
            set +x # avoid disclosure of passwords/tokens
            echo creating secret ${COMPONENT}-prediction-secret
            oc create secret generic ${COMPONENT}-prediction-secret --from-literal=username=${COMPONENT}-prediction-username --from-literal=password=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64  | rev | cut -b 2- | rev | tr -cd '[:alnum:]'` -n ${PROJECT}-${devenv}
            set -x
            oc set triggers dc/${COMPONENT}-${type} --from-config --remove -n ${PROJECT}-${devenv}
            oc set env dc/${COMPONENT}-${type} --env=DSI_TRAINING_BASE_URL=http://${COMPONENT}-training-service.${PROJECT}-${devenv}.svc:8080 -n ${PROJECT}-${devenv}
            oc set env dc/${COMPONENT}-${type} --from=secret/${COMPONENT}-training-secret --prefix=DSI_TRAINING_SERVICE_ -n ${PROJECT}-${devenv}
            oc set env dc/${COMPONENT}-${type} --from=secret/${COMPONENT}-prediction-secret --prefix=DSI_PREDICTION_SERVICE_ -n ${PROJECT}-${devenv}
            oc set triggers dc/${COMPONENT}-${type} --from-config -n ${PROJECT}-${devenv}
        fi

        # setting up resource limits: maximum of 2 CPU and 2GB memory, minimum of 0.25 CPU and 256MB memory
        oc set resources dc ${COMPONENT}-${type} --limits=cpu=2,memory=2Gi --requests=cpu=256m,memory=256Mi -n ${PROJECT}-${devenv}

    done
done
