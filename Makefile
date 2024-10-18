SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ODS_NAMESPACE := $(shell grep ODS_NAMESPACE $(CURDIR)/../ods-configuration/ods-core.env | cut -d "=" -f 2-)

# JENKINS AGENT
## Install or update Jenkins agent resources.
install-jenkins-agent: install-jenkins-agent-golang install-jenkins-agent-jdk install-jenkins-agent-nodejs install-jenkins-agent-python install-jenkins-agent-scala install-jenkins-agent-terraform install-jenkins-agent-terraform-2306 install-jenkins-agent-terraform-2408 install-jenkins-agent-rust
.PHONY: install-jenkins-agent

## Update OpenShift resources related Jenkins agent resources.
apply-jenkins-agent-build: apply-jenkins-agent-golang-build apply-jenkins-agent-jdk-build apply-jenkins-agent-nodejs16-build apply-jenkins-agent-nodejs18-build apply-jenkins-agent-nodejs20-build apply-jenkins-agent-nodejs22-build apply-jenkins-agent-python-build apply-jenkins-agent-scala-build apply-jenkins-agent-terraform-build apply-jenkins-agent-terraform-build-2306 apply-jenkins-agent-terraform-build-2408 apply-jenkins-agent-rust-build
.PHONY: apply-jenkins-agent-build

## Start builds of Jenkins agents.
start-jenkins-agent-build: start-jenkins-agent-golang-build start-jenkins-agent-jdk-build start-jenkins-agent-nodejs16-build start-jenkins-agent-nodejs18-build start-jenkins-agent-nodejs20-build apply-jenkins-agent-nodejs22-build start-jenkins-agent-python-build start-jenkins-agent-scala-build start-jenkins-agent-terraform-build start-jenkins-agent-terraform-build-2306 start-jenkins-agent-terraform-build-2408 start-jenkins-agent-rust-build
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


# JENKINS AGENT JDK
## Install or update Jenkins JDK agent resources.
install-jenkins-agent-jdk: apply-jenkins-agent-jdk-build start-jenkins-agent-jdk-build
.PHONY: install-jenkins-agent-jdk

## Update OpenShift resources related to Jenkins JDK agent image.
apply-jenkins-agent-jdk-build:
	cd common/jenkins-agents/jdk/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-jdk-build

## Start build of BuildConfig "jenkins-agent-jdk".
start-jenkins-agent-jdk-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-jdk --follow
.PHONY: start-jenkins-agent-jdk-build


# JENKINS AGENT NODEJS
## Install or update Jenkins Node agent resources.
install-jenkins-agent-nodejs: apply-jenkins-agent-nodejs16-build apply-jenkins-agent-nodejs18-build apply-jenkins-agent-nodejs20-build apply-jenkins-agent-nodejs22-build start-jenkins-agent-nodejs16-build start-jenkins-agent-nodejs18-build start-jenkins-agent-nodejs20-build start-jenkins-agent-nodejs22-build
.PHONY: install-jenkins-agent-nodejs

## Update OpenShift resources related to Jenkins Node 16 agent image.
apply-jenkins-agent-nodejs16-build:
	cd common/jenkins-agents/nodejs16/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-nodejs16-build

## Update OpenShift resources related to Jenkins Node 18 agent image.
apply-jenkins-agent-nodejs18-build:
	cd common/jenkins-agents/nodejs18/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-nodejs18-build

## Update OpenShift resources related to Jenkins Node 20 agent image.
apply-jenkins-agent-nodejs20-build:
	cd common/jenkins-agents/nodejs20/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-nodejs20-build

## Update OpenShift resources related to Jenkins Node 22 agent image.
apply-jenkins-agent-nodejs22-build:
	cd common/jenkins-agents/nodejs22/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-nodejs22-build

## Start build of BuildConfig "jenkins-agent-nodejs16".
start-jenkins-agent-nodejs16-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-nodejs16 --follow
.PHONY: start-jenkins-agent-nodejs16-build

## Start build of BuildConfig "jenkins-agent-nodejs18".
start-jenkins-agent-nodejs18-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-nodejs18 --follow
.PHONY: start-jenkins-agent-nodejs18-build

## Start build of BuildConfig "jenkins-agent-nodejs20".
start-jenkins-agent-nodejs20-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-nodejs20 --follow
.PHONY: start-jenkins-agent-nodejs20-build

## Start build of BuildConfig "jenkins-agent-nodejs22".
start-jenkins-agent-nodejs22-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-nodejs22 --follow
.PHONY: start-jenkins-agent-nodejs22-build

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


# JENKINS AGENT RUST
## Install or update Jenkins Rust agent resources.
install-jenkins-agent-rust: apply-jenkins-agent-rust-build start-jenkins-agent-rust-build
.PHONY: install-jenkins-agent-rust

## Update OpenShift resources related to Jenkins Rust agent image.
apply-jenkins-agent-rust-build:
	cd common/jenkins-agents/rust/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-rust-build

## Start build of BuildConfig "jenkins-agent-rust".
start-jenkins-agent-rust-build:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-rust --follow
.PHONY: start-jenkins-agent-rust-build


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


# JENKINS AGENT TERRAFORM-2306
## Install or update Jenkins Terraform agent resources.
install-jenkins-agent-terraform-2306: apply-jenkins-agent-terraform-build-2306 start-jenkins-agent-terraform-build-2306
.PHONY: install-jenkins-agent-terraform-2306

## Update OpenShift resources related to Jenkins Terraform agent image 2306.
apply-jenkins-agent-terraform-build-2306:
	cd common/jenkins-agents/terraform-2306/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-terraform-build-2306

## Start build of BuildConfig "jenkins-agent-terraform-2306".
start-jenkins-agent-terraform-build-2306:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-terraform-2306 --follow
.PHONY: start-jenkins-agent-terraform-build-2306


# JENKINS AGENT TERRAFORM-2408
## Install or update Jenkins Terraform agent resources.
install-jenkins-agent-terraform-2408: apply-jenkins-agent-terraform-build-2408 start-jenkins-agent-terraform-build-2408
.PHONY: install-jenkins-agent-terraform-2408

## Update OpenShift resources related to Jenkins Terraform agent image 2408.
apply-jenkins-agent-terraform-build-2408:
	cd common/jenkins-agents/terraform-2408/ocp-config && tailor apply --namespace $(ODS_NAMESPACE)
.PHONY: apply-jenkins-agent-terraform-build-2408

## Start build of BuildConfig "jenkins-agent-terraform-2408".
start-jenkins-agent-terraform-build-2408:
	oc -n $(ODS_NAMESPACE) start-build jenkins-agent-terraform-2408 --follow
.PHONY: start-jenkins-agent-terraform-build-2408


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
