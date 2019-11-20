# Python Jenkins Slave

## Introduction / Used for building `python` 
This slave is used to build / execute python code

The image is built in the global `cd` project and is named `jenkins-slave-python`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-python` 

## Features / what's in, which plugins, ...
1. Python 3.6
1. PIP

## Known limitations
Not (yet) Nexus package manager aware and no special HTTP Proxy configuration
