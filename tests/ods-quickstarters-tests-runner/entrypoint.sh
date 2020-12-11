#!/usr/bin/env bash

# Unset the corporate proxies
unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY

# Load all the env. vars from ods-core.env
export $(egrep -v '^#' ./ods-configuration/ods-core.env)

# Log into the OpenShift cluster
oc login --insecure-skip-tls-verify $OPENSHIFT_CONSOLE_HOST -n $ODS_NAMESPACE

# Enable the corporate proxies again before running the tests
# export NO_PROXY=<SET_VALUE>
# export no_proxy=$NO_PROXY 
# export http_proxy=<SET_VALUE>
# export https_proxy=<SET_VALUE>
# export HTTP_PROXY=$http_proxy 
# export HTTPS_PROXY=$https_proxy 

cd ods-quickstarters/tests

make test
