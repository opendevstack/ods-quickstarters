#!/usr/bin/env bash
# set -x
set +e
set -o pipefail

if [ -f test-quickstarter-results.txt ]; then
    rm test-quickstarter-results.txt
fi
go test -v -timeout 1h -p 1 github.com/opendevstack/ods-quickstarters/tests/... | tee test-quickstarter-results.txt 2>&1
exitcode="${PIPESTATUS[0]}"
if [ -f test-quickstarter-results.txt ]; then
    set -e
    go-junit-report < test-quickstarter-results.txt > test-quickstarter-report.xml
fi
exit $exitcode
