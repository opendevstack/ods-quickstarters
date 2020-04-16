# Node.js 12 - Jenkins Slave

## Introduction / Used for building `node.js`

This slave is used to build Node.js based projects, thru `npm`, `npx` and `yarn`

The image is built in the global `cd` project and is named `jenkins-slave-nodejs12`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-nodejs12`.

## Features

1. Nexus configuration
2. HTTP Proxy awareness

## Known limitations

n/a
