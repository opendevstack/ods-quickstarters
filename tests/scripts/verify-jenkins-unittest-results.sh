#!/usr/bin/env bash

BUILD_URL=$(oc get -n $2 build $1 -o json | jq '.metadata.annotations."openshift.io/jenkins-build-uri"' | sed 's/"//g' )
echo "Using $BUILD_URL/testReport calculated from $1 and searching for $3 tests"
result=$(curl ${BUILD_URL}/testReport --insecure --silent --location --header "Authorization: Bearer $(oc get sa/builder --template='{{range .secrets}}{{ .name }} {{end}}' | xargs -n 1 oc get secret --template='{{ if .data.token }}{{ .data.token }}{{end}}' | head -n 1 | base64 -d -)")
unittests=$(echo ${result} | grep "$3 tests")
if [ "${unittests}" == "" ]; then
	echo "Could not find ($3) unit test results for build $1 in project $2"
	exit 1
fi