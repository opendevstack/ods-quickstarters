SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

NAMESPACE=ods

# JENKINS
## Install or update Jenkins agent resources.
jenkins: apply-jenkins-build start-jenkins-build
.PHONY: jenkins

## Update OpenShift resources related to Jenkins agent images.
apply-jenkins-build: apply-jenkins-build-airflow apply-jenkins-build-golang apply-jenkins-build-maven apply-jenkins-build-nodejs10-angular apply-jenkins-build-python apply-jenkins-build-scala
.PHONY: apply-jenkins-build

## Update OpenShift resources related to Jenkins airflow agent image.
apply-jenkins-build-airflow:
	cd common/jenkins-agents/airflow/ocp-config && tailor apply --namespace ${NAMESPACE}
.PHONY: apply-jenkins-build-airflow

## Update OpenShift resources related to Jenkins golang agent image.
apply-jenkins-build-golang:
	cd common/jenkins-agents/golang/ocp-config && tailor apply --namespace ${NAMESPACE}
.PHONY: apply-jenkins-build-golang

## Update OpenShift resources related to Jenkins maven agent image.
apply-jenkins-build-maven:
	cd common/jenkins-agents/maven/ocp-config && tailor apply --namespace ${NAMESPACE}
.PHONY: apply-jenkins-build-maven

## Update OpenShift resources related to Jenkins nodejs agent image.
apply-jenkins-build-nodejs10-angular:
	cd common/jenkins-agents/nodejs10-angular/ocp-config && tailor apply --namespace ${NAMESPACE}
.PHONY: apply-jenkins-build-nodejs10-angular

## Update OpenShift resources related to Jenkins python agent image.
apply-jenkins-build-python:
	cd common/jenkins-agents/python/ocp-config && tailor apply --namespace ${NAMESPACE}
.PHONY: apply-jenkins-build-python

## Update OpenShift resources related to Jenkins scala agent image.
apply-jenkins-build-scala:
	cd common/jenkins-agents/scala/ocp-config && tailor apply --namespace ${NAMESPACE}
.PHONY: apply-jenkins-build-scala

## Start build of all Jenkins BuildConfig resources.
start-jenkins-build: start-jenkins-build-airflow start-jenkins-build-golang start-jenkins-build-maven start-jenkins-build-nodejs10-angular start-jenkins-build-python start-jenkins-build-scala
.PHONY: start-jenkins-build

## Start build of BuildConfig "jenkins-agent-airflow".
start-jenkins-build-airflow:
	oc -n ${NAMESPACE} start-build jenkins-agent-airflow --follow
.PHONY: start-jenkins-build-airflow

## Start build of BuildConfig "jenkins-agent-golang".
start-jenkins-build-golang:
	oc -n ${NAMESPACE} start-build jenkins-agent-golang --follow
.PHONY: start-jenkins-build-golang

## Start build of BuildConfig "jenkins-agent-maven".
start-jenkins-build-maven:
	oc -n ${NAMESPACE} start-build jenkins-agent-maven --follow
.PHONY: start-jenkins-build-maven

## Start build of BuildConfig "jenkins-agent-nodejs".
start-jenkins-build-nodejs10-angular:
	oc -n ${NAMESPACE} start-build jenkins-agent-nodejs10-angular --follow
.PHONY: start-jenkins-build-nodejs10-angular

## Start build of BuildConfig "jenkins-agent-golang".
start-jenkins-build-python:
	oc -n ${NAMESPACE} start-build jenkins-agent-python --follow
.PHONY: start-jenkins-build-python

## Start build of BuildConfig "jenkins-agent-scala".
start-jenkins-build-scala:
	oc -n ${NAMESPACE} start-build jenkins-agent-scala --follow
.PHONY: start-jenkins-build-scala

# HELP
# Based on https://gist.github.com/prwhite/8168133#gistcomment-2278355.
help:
	@echo ''
	@echo 'Usage:'
	@echo '  make <target>'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  %-35s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
.PHONY: help
