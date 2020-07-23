#!/usr/bin/env bash

BUILD_URL=$(oc get -n $2 build $1 -o json | jq '.metadata.annotations."openshift.io/jenkins-build-uri"' | sed 's/"//g' )
echo $BUILD_URL
ARTIFACT_URL=$BUILD_URL/artifact/artifacts/$3
echo "grabbing artifact from $ARTIFACT_URL - and storing in /tmp"
httpCode=$(curl ${INSECURE} --silent --fail ${ARTIFACT_URL} --header "Authorization: Bearer $(oc get sa/builder --template='{{range .secrets}}{{ .name }} {{end}}' | xargs -n 1 oc get secret --template='{{ if .data.token }}{{ .data.token }}{{end}}' | head -n 1 | base64 -d -)" -k -o /tmp/$3 -w "%{http_code}")
echo "response: $httpCode"
if [ ! "${httpCode}" == "200" ]; then
	echo "Could not find artifact $3 - url: $ARTIFACT_URL"
	exit 1
fi