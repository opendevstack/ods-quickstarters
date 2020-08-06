#!/usr/bin/env bash
set -eu
set -o pipefail

# By default we run all quickstarter tests, otherwise just the quickstarter
# passed as the first argument to this script.
QUICKSTARTER=${1-...}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ODS_QUICKSTARTERS_DIR=${SCRIPT_DIR%/*}

ODS_NAMESPACE=$(${ODS_QUICKSTARTERS_DIR}/scripts/get-config-param.sh ODS_NAMESPACE)
OPENSHIFT_APPS_BASEDOMAIN=$(${ODS_QUICKSTARTERS_DIR}/scripts/get-config-param.sh OPENSHIFT_APPS_BASEDOMAIN)
export PROVISION_API_HOST=https://prov-app-${ODS_NAMESPACE}${OPENSHIFT_APPS_BASEDOMAIN}
echo "PROVISION_API_HOST = ${PROVISION_API_HOST}"

if ! oc whoami &> /dev/null; then
    echo "You need to login to OpenShift to run the tests"
    exit 1
fi

if [ -f test-quickstarter-results.txt ]; then
    rm test-quickstarter-results.txt
fi

BITBUCKET_TEST_PROJECT="unitt"
echo "Setup Bitbucket test project ${BITBUCKET_TEST_PROJECT} ..."
BITBUCKET_URL=$(${ODS_QUICKSTARTERS_DIR}/scripts/get-config-param.sh BITBUCKET_URL)
CD_USER_ID=$(${ODS_QUICKSTARTERS_DIR}/scripts/get-config-param.sh CD_USER_ID)
CD_USER_PWD_B64=$(${ODS_QUICKSTARTERS_DIR}/scripts/get-config-param.sh CD_USER_PWD_B64)
./scripts/setup-bitbucket-test-project.sh \
    --bitbucket=${BITBUCKET_URL} \
    --user=${CD_USER_ID} \
    --password=$(base64 -d - <<< ${CD_USER_PWD_B64}) \
    --project=${BITBUCKET_TEST_PROJECT}

echo "Running tests (${QUICKSTARTER}). Output will take a while to arrive ..."

go test -v -count=1 -timeout 1h -p 4 github.com/opendevstack/ods-quickstarters/tests/${QUICKSTARTER} | tee test-quickstarter-results.txt 2>&1
exitcode="${PIPESTATUS[0]}"
if [ -f test-quickstarter-results.txt ]; then
    go-junit-report < test-quickstarter-results.txt > test-quickstarter-report.xml
fi
exit $exitcode
