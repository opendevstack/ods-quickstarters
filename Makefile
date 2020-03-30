SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# JENKINS
## Install or update Jenkins agent resources.
jenkins: jenkins-apply-build jenkins-start-build
.PHONY: jenkins

## Update OpenShift resources related to Jenkins agent images.
jenkins-apply-build: jenkins-apply-build-airflow jenkins-apply-build-golang jenkins-apply-build-maven jenkins-apply-build-nodejs jenkins-apply-build-python jenkins-apply-build-scala
.PHONY: jenkins-apply-build

## Update OpenShift resources related to Jenkins airflow agent image.
jenkins-apply-build-airflow:
	cd common/jenkins-slaves/airflow/ocp-config && tailor apply
.PHONY: jenkins-apply-build-airflow

## Update OpenShift resources related to Jenkins golang agent image.
jenkins-apply-build-golang:
	cd common/jenkins-slaves/golang/ocp-config && tailor apply
.PHONY: jenkins-apply-build-golang

## Update OpenShift resources related to Jenkins maven agent image.
jenkins-apply-build-maven:
	cd common/jenkins-slaves/maven/ocp-config && tailor apply
.PHONY: jenkins-apply-build-maven

## Update OpenShift resources related to Jenkins nodejs agent image.
jenkins-apply-build-nodejs:
	cd common/jenkins-slaves/nodejs10-angular/ocp-config && tailor apply
.PHONY: jenkins-apply-build-nodejs

## Update OpenShift resources related to Jenkins python agent image.
jenkins-apply-build-python:
	cd common/jenkins-slaves/python/ocp-config && tailor apply
.PHONY: jenkins-apply-build-python

## Update OpenShift resources related to Jenkins scala agent image.
jenkins-apply-build-scala:
	cd common/jenkins-slaves/scala/ocp-config && tailor apply
.PHONY: jenkins-apply-build-scala

## Start build of all Jenkins BuildConfig resources.
jenkins-start-build: jenkins-start-build-airflow jenkins-start-build-golang jenkins-start-build-maven jenkins-start-build-nodejs jenkins-start-build-python jenkins-start-build-scala
.PHONY: jenkins-start-build

## Start build of BuildConfig "jenkins-slave-airflow".
jenkins-start-build-airflow:
	oc -n cd start-build jenkins-slave-airflow --follow
.PHONY: jenkins-start-build-airflow

## Start build of BuildConfig "jenkins-slave-golang".
jenkins-start-build-golang:
	oc -n cd start-build jenkins-slave-golang --follow
.PHONY: jenkins-start-build-golang

## Start build of BuildConfig "jenkins-slave-maven".
jenkins-start-build-maven:
	oc -n cd start-build jenkins-slave-maven --follow
.PHONY: jenkins-start-build-maven

## Start build of BuildConfig "jenkins-slave-nodejs".
jenkins-start-build-nodejs:
	oc -n cd start-build jenkins-slave-nodejs --follow
.PHONY: jenkins-start-build-nodejs

## Start build of BuildConfig "jenkins-slave-golang".
jenkins-start-build-python:
	oc -n cd start-build jenkins-slave-python --follow
.PHONY: jenkins-start-build-python

## Start build of BuildConfig "jenkins-slave-scala".
jenkins-start-build-scala:
	oc -n cd start-build jenkins-slave-scala --follow
.PHONY: jenkins-start-build-scala

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
