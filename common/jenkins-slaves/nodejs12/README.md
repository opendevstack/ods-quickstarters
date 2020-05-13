# Node.js 12 - Jenkins Slave

## Introduction

This slave is used to build [Node.js v12.x](https://nodejs.org/dist/latest-v12.x/docs/api/) based projects, through `npm`, `npx` and `yarn`. The [`jenkins-slave-base`](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base) is used as base image.

The image is built in the global `cd` project and is named `jenkins-slave-nodejs12`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-nodejs12`.

```groovy
odsPipeline(
    image: "${dockerRegistry}/cd/jenkins-slave-nodejs12",
)
```

## Features

1. Nodes.js v12.x
2. npm / npx v6.x
3. yarn v1.X
4. Nexus configuration
5. HTTP Proxy awareness

## Known Limitations

**Coming from `jenkins-slave-nodejs10-angular`:**

There are no more any `angular`, `cypress` and/or `chrome` dependencies included - this is a plain `Node.js v12.x` jenkins slave! If you still need these requirements, you can create a customized jenkins slave and use `jenkins-slave-nodejs12` as base image.
