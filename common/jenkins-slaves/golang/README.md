# Go Jenkins Slave

## Introduction
This slave is used to build / execute / test [Go](https://golang.org) code.

The image is built in the global `cd` project and is named `jenkins-slave-golang`.
It can be referenced in a `Jenkinsfile` with e.g. `cd/jenkins-slave-golang:latest`.

## Features / what's in, which plugins, ...
1. Go 1.12.6
2. golangci-lint 1.17.1

## Known limitations
Not (yet) Nexus package manager aware and no special HTTP Proxy configuration.
