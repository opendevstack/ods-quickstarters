.PHONY: test lint

test: docker-plain/jenkinsfile_test.go go.mod go.sum
	@(echo "Verifying ODS quickstarters")
	@(./quickstarter-test.sh)

setup-tests: 
	echo "legacy .."

lint:
	echo "Checking code ..."
	golangci-lint run
