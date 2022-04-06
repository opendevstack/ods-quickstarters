SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ODS_NAMESPACE := $(shell grep ODS_NAMESPACE $(CURDIR)/../ods-configuration/ods-core.env | cut -d "=" -f 2-)

# JENKINS AGENT
## Install or update Jenkins agent resources.
install-jenkins-agent: install-jenkins-agent-golang install-jenkins-agent-maven install-jenkins-agent-nodejs install-jenkins-agent-python install-jenkins-agent-scala install-jenkins-agent-terraform
.PHONY: install-jenkins-agent

## Update OpenShift resources related Jenkins agent resources.
apply-jenkins-agent-build: apply-jenkins-agent-golang-build apply-jenkins-agent-maven-build apply-jenkins-agent-nodejs12-build apply-jenkins-agent-nodejs16-build apply-jenkins-agent-python-build apply-jenkins-agent-scala-build apply-jenkins-agent-terraform-build
.PHONY: apply-jenkins-agent-build

## Start builds of Jenkins agents.
start-jenkins-agent-build: start-jenkins-agent-golang-build start-jenkins-agent-maven-build start-jenkins-agent-nodejs12-build start-jenkins-agent-nodejs16-build start-jenkins-agent-python-build start-jenkins-agent-scala-build start-jenkins-agent-terraform-build
.PHONY: start-jenkins-agent-build


# JENKINS AGENT GO
## Install or update Jenkins Go agent resources.
install-jenkins-agent-golang: apply-jenkins-agent-golang-build start-jenkins-agent-golang-build
.PHONY: install-jenkins-agent-golang

## Update OpenShift resources related to Jenkins Go agent image.
apply-jenkins-agent-golang-build:
	cd common/jenkins-agents/golang/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-golang-build

## Start build of BuildConfig "jenkins-agent-golang".
start-jenkins-agent-golang-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-golang --follow
.PHONY: start-jenkins-agent-golang-build


# JENKINS AGENT MAVEN
## Install or update Jenkins Maven agent resources.
install-jenkins-agent-maven: apply-jenkins-agent-maven-build start-jenkins-agent-maven-build
.PHONY: install-jenkins-agent-maven

## Update OpenShift resources related to Jenkins Maven agent image.
apply-jenkins-agent-maven-build:
	cd common/jenkins-agents/maven/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-maven-build

## Start build of BuildConfig "jenkins-agent-maven".
start-jenkins-agent-maven-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-maven --follow
.PHONY: start-jenkins-agent-maven-build


# JENKINS AGENT NODEJS
## Install or update Jenkins Node agent resources.
install-jenkins-agent-nodejs: apply-jenkins-agent-nodejs12-build apply-jenkins-agent-nodejs16-build start-jenkins-agent-nodejs12-build start-jenkins-agent-nodejs16-build
.PHONY: install-jenkins-agent-nodejs

## Update OpenShift resources related to Jenkins Node agent image.
apply-jenkins-agent-nodejs12-build:
	cd common/jenkins-agents/nodejs12/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-nodejs12-build

apply-jenkins-agent-nodejs16-build:
	cd common/jenkins-agents/nodejs16/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-nodejs16-build

## Start build of BuildConfig "jenkins-agent-nodejs*".
start-jenkins-agent-nodejs12-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-nodejs12 --follow
.PHONY: start-jenkins-agent-nodejs12-build

start-jenkins-agent-nodejs16-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-nodejs16 --follow
.PHONY: start-jenkins-agent-nodejs16-build

# JENKINS AGENT PYTHON
## Install or update Jenkins Python agent resources.
install-jenkins-agent-python: apply-jenkins-agent-python-build start-jenkins-agent-python-build
.PHONY: install-jenkins-agent-python

## Update OpenShift resources related to Jenkins Python agent image.
apply-jenkins-agent-python-build:
	cd common/jenkins-agents/python/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-python-build

## Start build of BuildConfig "jenkins-agent-python".
start-jenkins-agent-python-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-python --follow
.PHONY: start-jenkins-agent-python-build


# JENKINS AGENT SCALA
## Install or update Jenkins Scala agent resources.
install-jenkins-agent-scala: apply-jenkins-agent-scala-build start-jenkins-agent-scala-build
.PHONY: install-jenkins-agent-scala

## Update OpenShift resources related to Jenkins Scala agent image.
apply-jenkins-agent-scala-build:
	cd common/jenkins-agents/scala/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-scala-build

## Start build of BuildConfig "jenkins-agent-scala".
start-jenkins-agent-scala-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-scala --follow
.PHONY: start-jenkins-agent-scala-build


# JENKINS AGENT TERRAFORM
## Install or update Jenkins Terraform agent resources.
install-jenkins-agent-terraform: apply-jenkins-agent-terraform-build start-jenkins-agent-terraform-build
.PHONY: install-jenkins-agent-terraform

## Update OpenShift resources related to Jenkins Terraform agent image.
apply-jenkins-agent-terraform-build:
	cd common/jenkins-agents/terraform/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-terraform-build

## Start build of BuildConfig "jenkins-agent-terraform".
start-jenkins-agent-terraform-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-terraform --follow
.PHONY: start-jenkins-agent-terraform-build


# HELP
# Based on https://gist.github.com/prwhite/8168133#gistcomment-2278355.
help:
	@echo ''
	@echo 'Usage:'
	@echo '  make <target>'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:|^# .*/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  %-35s %s\n", helpCommand, helpMessage; \
		} else { \
			printf "\n"; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
.PHONY: help
