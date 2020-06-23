.PHONY: test lint

test: docker-plain/jenkinsfile_test.go go.mod go.sum
	# go test -count=1 -v github.com/opendevstack/ods-quickstarters/tests/docker-plain	
	go test -count=1 -v github.com/opendevstack/ods-quickstarters/tests/be-typescript-express	

setup-tests: test-setup/main.go
	 go build -o test-setup.bin test-setup/main.go
	 ./test-setup.bin
lint:
	echo "Checking code ..."
	golangci-lint run
