#!/usr/bin/env bash
# set -x
set +e
set -o pipefail

if [ -f test-quickstarter-results.txt ]; then
    rm test-quickstarter-results.txt
fi
go test -v github.com/opendevstack/ods-quickstarters/... | tee test-quickstarter-results.txt 2>&1
exitcode=$?
if [ -f test-quickstarter-results.txt ]; then
    set -e
    go-junit-report < test-quickstarter-results.txt > test-quickstarter-report.xml
fi
exit $exitcode
