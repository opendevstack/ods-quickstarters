NAME                     := AWS Prototype
DESCRIPTION              := The '$(NAME)' is a is a prototype for an ODS quickstarter
VERSION                  := $(shell cat ./VERSION | tr -d [:space:])

GIT_REMOTE_ORIGIN_URI    := $(shell git remote get-url origin)
GIT_REMOTE_UPSTREAM_NAME := upstream
GIT_REMOTE_UPSTREAM_URI  := ssh://git@bitbucket.biscrum.com:7999/infiaas/stack-aws-skeleton.git

RELEASE_EMAIL_FROM       := 
RELEASE_EMAIL_TO         := 

PWD                      := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GEMS_HOME                ?= $(PWD)/vendor/bundle
INSTALL_REPORT_HOME      := ./reports/install
SHELL                    := /usr/bin/env bash

TF_WORKSPACE             = default


default: test

all: test plan deploy smoke-test describe

.PHONY: init
# Initialize project.
init: install-dev-deps install-test-deps

.PHONY: create-tfvars
# create terraform.tfvars.json
create-tfvars:  
	terraform-docs json . | jq '.inputs | map({ (.name): .default }) | add' > terraform.tfvars.json

.PHONY: test
# Run (pre-deployment) tests.
test: install-test-deps test-terraform-modules
	$(call check_defined,AWS_ACCESS_KEY_ID)
	$(call check_defined,AWS_SECRET_ACCESS_KEY)
	$(call check_defined,AWS_DEFAULT_REGION)

	# output aws account and user id for testing
	aws sts  get-caller-identity --output text | tee $(INSTALL_REPORT_HOME)/aws_testing_account.log
			
	# Remove any previously created Terraform test artefacts.
	for dir in .terraform terraform.tfstate.d; do \
		find test/fixtures -name $$dir -print0 | xargs -0 rm -rf; \
	done \

	inspec_profiles=$$(ls -1 ./test/integration); \
	for fdir in $$inspec_profiles; do \
		mkdir -p test/integration/$$fdir/files ; \
		pipenv run hcl2tojson test/fixtures/$$fdir/main.tf  test/integration/$$fdir/files/main.json; \
    done \

	# See https://github.com/hashicorp/terraform/issues/17655 for TF_WARN_OUTPUT_ERRORS=1.
	# See https://github.com/test-kitchen/test-kitchen/issues/1436 for why a simple `bundle exec kitchen test` is not an option.
	for suite in $$(bundle exec kitchen list --bare); do \
		TF_WARN_OUTPUT_ERRORS=1 bundle exec kitchen verify $$suite || { bundle exec kitchen destroy $$suite; exit 1; }; \
		bundle exec kitchen destroy $$suite; \
	done

.PHONY: release
# Create and push a release branch and tag for VERSION.
release: test
	$(call exit_if_release_exists,$(VERSION))

	$(call git_create_branch,release-v$(VERSION))
		$(call git_push,release-v$(VERSION))

		$(call git_create_tag,$(VERSION))
		$(call git_push,v$(VERSION))
		git checkout master
	$(call send_release_email)

.PHONY: plan
# Plan infrastructure deployment.
plan: init-terraform
	$(call check_defined,AWS_ACCESS_KEY_ID)
	$(call check_defined,AWS_SECRET_ACCESS_KEY)
	$(call check_defined,AWS_DEFAULT_REGION)

	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform plan -input=false -out=tfplan

.PHONY: deploy
# Deploy infrastructure.
deploy: init-terraform plan
	$(call check_defined,AWS_ACCESS_KEY_ID)
	$(call check_defined,AWS_SECRET_ACCESS_KEY)
	$(call check_defined,AWS_DEFAULT_REGION)

	# output aws account and user id for testing
	aws sts  get-caller-identity --output text | tee $(INSTALL_REPORT_HOME)/aws_deploy_account.log
		
	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform apply -auto-approve -input=false -no-color tfplan | tee "$(INSTALL_REPORT_HOME)/tf_apply.log"
	@TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform show -no-color -json | tee "$(INSTALL_REPORT_HOME)/tf_show.log" 1>/dev/null

.PHONY: smoke-test
# Run (post-deployment) tests.
smoke-test: install-test-deps
	$(call check_defined,AWS_ACCESS_KEY_ID)
	$(call check_defined,AWS_SECRET_ACCESS_KEY)
	$(call check_defined,AWS_DEFAULT_REGION)
    
	sh ./lib/scripts/createstackoutputs2yml.sh
	inspec_profiles=$$(ls -1 ./test/integration); \
	for profile in $$inspec_profiles; do \
		JSON_VARS_FILE="$(PWD)/terraform.tfvars.json" bundle exec cinc-auditor exec ./test/integration/$$profile --no-create-lockfile --input-file ./test/integration/$$profile/files/inputs-from-tfo-stack.yml --reporter=cli junit2:build/test-results/test/$$profile.xml json:reports/install/data/inspec/post-install/$$profile.json --target aws://; \
	done

.PHONY: describe
# Describe infrastructure.
describe: init-terraform
	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform output -json | tee outputs.json

.PHONY: destroy
# Destroy infrastructure.
destroy: init-terraform
	$(call check_defined,AWS_ACCESS_KEY_ID)
	$(call check_defined,AWS_SECRET_ACCESS_KEY)
	$(call check_defined,AWS_DEFAULT_REGION)

	TF_IN_AUTOMATION=1 TF_WORKSPACE="$(TF_WORKSPACE)" terraform destroy -auto-approve


.PHONY: merge-upstream
# Merge the upstream remote's master branch into this repository's current branch.
merge-upstream:
	$(call git_add_remote,$(GIT_REMOTE_UPSTREAM_NAME),$(GIT_REMOTE_UPSTREAM_URI))
	git fetch $(GIT_REMOTE_UPSTREAM_NAME)
	git merge $(GIT_REMOTE_UPSTREAM_NAME)/master

.PHONY: merge-upstream011
# Merge the upstream remote's terraform011 branch into this repository's current branch.
merge-upstream011:
	$(call git_add_remote,$(GIT_REMOTE_UPSTREAM_NAME),$(GIT_REMOTE_UPSTREAM_URI))
	git fetch $(GIT_REMOTE_UPSTREAM_NAME)
	git merge $(GIT_REMOTE_UPSTREAM_NAME)/terraform011

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
	BUNDLE_SILENCE_ROOT_WARNING=true bundle install --path $(GEMS_HOME) --jobs=8

.PHONY: install-python-env
# Install python virtual environment based on Pipfile
install-python-env:
	PIPENV_VENV_IN_PROJECT=true pipenv install

.PHONY: init-terraform
# Install Terraform workspace.
init-terraform:
	echo 1 | terraform init -backend=true -force-copy -input=false -backend-config="workspace_key_prefix=$(PREFIX)" -backend-config="key=$(S3KEY)/terraform.tfstate"

.PHONY: install-test-deps
# Install testing dependencies.
install-test-deps: install-ruby-gems install-python-env

.PHONY: test-terraform-modules
# Run Terraform modules tests.
test-terraform-modules:
ifeq ($(WITH_DEEP_TESTING),1)
	$(call check_defined,AWS_ACCESS_KEY_ID)
	$(call check_defined,AWS_SECRET_ACCESS_KEY)
	$(call check_defined,AWS_DEFAULT_REGION)

	# Remove any previously installed modules.
	if [ -d .terraform ]; then \
		find .terraform -name modules -type d -print0 | xargs -0 rm -rf; \
	fi

	# Fetch Terraform modules.
	terraform get -update=true

	# Run included blueprint tests.
	$(call test_included_blueprints)
endif

.PHONY: tf012upgrade
# Migrate to terraform 0.12, upgrade from skeleton, precheck and run the upgrade command
# https://www.terraform.io/upgrade-guides/0-12.html
tf012upgrade:
	mv backend.tf backned.tf.UPGRADE12.START

	for suite in $$(ls -d . test/fixtures/*); do \
		rm -Rf $$suite/.terraform ; \
		/usr/local/bin/terraform11 init $$suite ; \
		/usr/local/bin/terraform11 0.12checklist $$suite || exit 1 ; \
	done

	for suite in $$(ls -d . test/fixtures/*); do \
		rm -Rf $$suite/.terraform ; \
		/usr/local/bin/terraform12 init $$suite ; \
		/usr/local/bin/terraform12 0.12upgrade -yes $$suite || exit 1 ; \
	done

	mv backned.tf.UPGRADE12.START backend.tf

	git status


# Checks if a variable is defined and produces a fatal error if not.
check_defined = \
	$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
	$(if $(value $1),, \
		$(error Undefined $1$(if $2, ($2))$(if $(value @), \
			required by target `$@')))

# Exits with an error if a given release already exists.
exit_if_release_exists = \
	if git branch -a | grep -q -e release-v$(1); then \
		echo "Error: a release with version $(1) already exists.";  \
		exit 1;  \
	fi

# Adds a Git remote if it doesn't exist already.
git_add_remote = \
	if ! git remote -v | grep -q -e $(1); then \
		git remote add $(1) $(2); \
	fi

# Creates and switches to a new Git branch.
git_create_branch = \
	git checkout -b $(1)

# Creates an annotated Git tag.
git_create_tag = \
	git tag -a v$(1) -m v$(1)

# Updates the origin remote with local changes.
git_push = \
	git push origin $(1)

# Computes a URL from a Git URI.
git_uri_to_url = \
	$(shell \
		GIT_URL=`echo "$(1)" | sed 's/:/\//g'`; \
		GIT_URL=`echo "$${GIT_URL}" | sed 's/^git@/https:\/\//'`; \
		GIT_URL=`echo "$${GIT_URL}" | sed 's/.git$$//'`; \
		echo "$${GIT_URL}")

# Sends an email to announce a new release.
send_release_email = \
	$(shell \
		FROM="$(RELEASE_EMAIL_FROM)"; \
		TO="$(RELEASE_EMAIL_TO)"; \
		SUBJECT="New Release: $(NAME) v$(VERSION)"; \
		BODY="Available at $(call git_uri_to_url,$(GIT_REMOTE_ORIGIN_URI))."; \
		mail -s "$${SUBJECT}" -r "$${FROM}" "$${TO}" <<< "$${BODY}")

# Execute tests in included blueprints.
test_included_blueprints = \
	function test_blueprint() { \
		dir=$$(echo $$1 | jq -r '.Dir'); \
		source=$$(echo $$1 | jq -r '.Source'); \
		\
		source=$$(basename $$source); \
		if echo "$$source" | grep -q -e '\?ref='; then \
			source=$$(echo $$source | sed 's/\(\.*\)?ref=.*/$1/'); \
		fi; \
		if echo "$$source" | grep -q -e '\.git$$'; then \
			source=$$(echo $$source | sed 's/\(\.*\).git$$/$1/'); \
		fi; \
		\
		if [ -f "$$dir/Makefile" ] && [ $$(grep -c "^test-report:" "$$dir/Makefile") == 1 ]; then \
			echo "Running tests for module $$source in $$dir."; \
			mkdir -p ./reports/install/data/blueprints/reports/test; \
			GEMS_HOME=$(GEMS_HOME) make test-report -C $$dir || exit 1; \
			cp "$$dir/reports/test/report.json" "./reports/install/data/blueprints/reports/test/$$source.json"; \
		else \
			echo "Module $$source in $$dir does not contain a valid Makefile. No tests executed."; \
		fi \
	}; \
	\
	if [ -f .terraform/modules/modules.json ]; then \
		export -f test_blueprint; \
		jq -c '.Modules | unique_by(.Source) | map(select(.Dir != ".")) | .[]' .terraform/modules/modules.json | parallel --halt soon,fail=1 --line-buffer --keep-order --quote test_blueprint "{}"; \
	fi
