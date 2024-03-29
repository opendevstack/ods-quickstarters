NAME                     := AWS Quickstarter
DESCRIPTION              := The '$(NAME)' is a is a prototype for an ODS quickstarter

PWD                      := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GEMS_HOME                ?= $(PWD)/vendor/bundle
INSTALL_REPORT_HOME      := ./reports/install
SHELL                    := /usr/bin/env bash
.SHELLFLAGS              := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS                += --warn-undefined-variables
MAKEFLAGS                += --no-builtin-rules

TF_WORKSPACE             = default

# tfenv hack
DEBUG                    := 0

# Statefile Parameters
ACCOUNT_ID               := $(shell aws sts get-caller-identity --query 'Account' --output text)
TF_BACKEND_S3KEY_MOD     := $(shell echo "$(TF_BACKEND_S3KEY)" | sed "s/\//-/g")
TF_BACKEND_S3KEY_MOD     := $(shell echo "$(TF_BACKEND_S3KEY_MOD)" | sed "s/-/\//")

TFSTATE_BUCKET           := $(ACCOUNT_ID)-terraform-state-bucket
TFSTATE_KEY              := $(TF_BACKEND_S3KEY_MOD)-terraform-state
TFSTATE_TABLE            := $(ACCOUNT_ID)-terraform-state-lock-table


.PHONY: default
default: test

.PHONY: all
all: test plan deploy deployment-test describe

.PHONY: init
# Initialize project.
init: install-dev-deps install-test-deps

.PHONY: create-tfvars
# create terraform.tfvars.json
create-tfvars:
	terraform-docs json . | jq '.inputs | map({ (.name): .default }) | add' > terraform.tfvars.json

.PHONY: prep-test
prep-test:
	pre-commit run terraformcreatei2o -a
	pre-commit run terraformstackmoduleoutputs -a

.PHONY: test
# Run (pre-deployment) tests.
test: install-test-deps
	#Needed for "Infrastructure as Code (IaC)" stage

.PHONY: plan
# Plan infrastructure deployment.
plan: init-terraform
	@$(call check_aws_credentials)

	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform plan -input=false -out=tfplan

.PHONY: deploy
# Deploy infrastructure.
deploy: init-terraform plan
	@$(call check_aws_credentials)

	# output aws account and user id for testing
	aws sts  get-caller-identity --output text | tee $(INSTALL_REPORT_HOME)/aws_deploy_account.log

	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform apply -auto-approve -input=false -no-color tfplan | tee "$(INSTALL_REPORT_HOME)/tf_apply.log"
	@TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform show -no-color -json | tee "$(INSTALL_REPORT_HOME)/tf_show.log" 1>/dev/null

.PHONY: deployment-test
# Run (post-deployment) tests.
deployment-test: install-test-deps
	#Needed for "Infrastructure as Code (IaC)" stage

.PHONY: install-report
install-report:
	awk '/Creation complete/  && !/terraform-data/ {print}' "$(INSTALL_REPORT_HOME)/tf_apply.log" > $(INSTALL_REPORT_HOME)/tf_created.log

.PHONY: describe
# Describe infrastructure.
describe: init-terraform
	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform output -json | tee outputs.json

.PHONY: destroy
# Destroy infrastructure.
destroy: init-terraform
	@$(call check_aws_credentials)

	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform destroy -auto-approve

.PHONY: install-dev-deps
# Install development dependencies.
install-dev-deps: install-git-pre-commit-hooks

.PHONY: install-git-pre-commit-hooks
# Install Git pre-commit hooks.
install-git-pre-commit-hooks:
	pre-commit install --overwrite

.PHONY: install-ruby-gems
# Install Ruby gems specified in Gemfile.
install-ruby-gems:
	BUNDLE_SILENCE_ROOT_WARNING=true bundle config --local path $(GEMS_HOME)
	# see https://github.com/rubygems/rubygems/issues/4466 to get rid of error messages in Jenkins
	BUNDLE_SILENCE_ROOT_WARNING=true TMPDIR=./vendor/tmp bundle install --jobs=8

.PHONY: install-python-env
# Install python virtual environment based on Pipfile
install-python-env:
	CI=true PIPENV_VENV_IN_PROJECT=true pipenv install

.PHONY: init-terraform
# Install Terraform workspace.
init-terraform:

	@echo "Bucket: ${TFSTATE_BUCKET}"
	@echo "Key   : ${TFSTATE_KEY}"
	@echo "Table : ${TFSTATE_TABLE}"

	echo 1 | terraform init -backend-config="bucket=$(TFSTATE_BUCKET)" -backend-config="key=$(TFSTATE_KEY)" -backend-config="dynamodb_table=$(TFSTATE_TABLE)" -force-copy -input=false

.PHONY: install-test-deps
# Install testing dependencies.
install-test-deps: install-ruby-gems install-python-env

.PHONY: cinc-auditor-test
# run cinc-auditor without use of kitchen-terraform and create yaml for mapping terraform outputs to inspec inputs.
cinc-auditor-test:
	sh ./lib/scripts/createstackfixtureoutputs2yml.sh
	bundle exec cinc-auditor exec test/integration/default --no-create-lockfile --no-distinct-exit --input-file ./test/integration/default/files/inputs-from-tfo-stack.yml --target aws://

.PHONY: clean
# Reset Working directory (take care if something has deployed upfront)
clean:
	@rm -rf .kitchen/
	@rm -rf test/fixtures/default/terraform.tfstate.d/
	@rm -rf test/fixtures/default/.terraform/
	@rm -f test/fixtures/default/.terraform.lock.hcl

.PHONY: check-config
# Do some basic verification of configuration files and accounts
check-config:
	@sh ./lib/scripts/aws/check_conf.sh

# Checks AWS account
check_aws_credentials = \
    exitStatus=0; \
	if [ -v  AWS_ACCESS_KEY_ID ] && [ -v  AWS_SECRET_ACCESS_KEY ]; then \
		echo "Info: using AWS environment variables AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY ..."; \
	else \
		aws sts get-caller-identity &> /dev/null || exitStatus=$$?; \
		if [ $$exitStatus = 0  ]; then \
			echo "Info: using alternate credentials (e.g. AWS SSO) ..."; \
  		else \
			echo "Error: No AWS credentials specified ..."; exit 1; \
		fi \
	fi
