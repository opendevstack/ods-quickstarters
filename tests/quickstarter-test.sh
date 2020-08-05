#!/usr/bin/env bash
# set -x
set +e
set -o pipefail

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

echo "Running tests ... output will take a while to arrive ..."

go test -v -count=1 -timeout 1h -p 4 github.com/opendevstack/ods-quickstarters/tests/... | tee test-quickstarter-results.txt 2>&1
exitcode="${PIPESTATUS[0]}"
if [ -f test-quickstarter-results.txt ]; then
    set -e
    go-junit-report < test-quickstarter-results.txt > test-quickstarter-report.xml
fi
exit $exitcode
