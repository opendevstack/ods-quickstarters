.PHONY: test test-docker lint

QUICKSTARTER := "..."
UMBRELLA_DIR := $(shell cd $(CURDIR)/../../ && pwd)

test: docker-plain/jenkinsfile_test.go go.mod go.sum
	@(echo "Verifying ODS quickstarters")
	@(./quickstarter-test.sh $(QUICKSTARTER))

# Builds the Docker image to ship all the deps required
# and runs the quickstarter tests.
test-docker: build-qs-tests-runner-image run-qs-tests-runner-image

build-qs-tests-runner-image:
	cd ods-quickstarters-tests-runner && \
	docker build --tag ods-quickstarters-tests-runner .
.PHONY: build-qs-tests-runner-image

run-qs-tests-runner-image:	
	cd $(UMBRELLA_DIR) && docker run --rm -it -v $(UMBRELLA_DIR):/work ods-quickstarters-tests-runner
.PHONY: run-qs-tests-runner-image

setup-tests: 
	echo "legacy .."

lint:
	echo "Checking code ..."
	golangci-lint run
