# Scala / SBT Jenkins Slave

## Introduction / Used for building `scala` 
This slave is used to build scala code thru SBT (Scala build tool)

The image is built in the global `cd` project and is named `jenkins-slave-scala`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-scala`

## Features / what's in, which plugins, ...
1. SBT 1.1.6
1. HTTP Proxy aware
1. Nexus aware

## Known limitations
In case HTTP Proxy config is injected thru environment variables (including NO_PROXY), Nexus configuration is disabled because of an SBT bug
