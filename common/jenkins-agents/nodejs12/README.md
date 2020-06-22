# Node.js 12 - Jenkins agent

## Introduction

This agent is used to build [Node.js v12.x](https://nodejs.org/dist/latest-v12.x/docs/api/) based projects, through `npm`, `npx` and `yarn`. The [`jenkins-agent-base`](https://github.com/opendevstack/ods-core/tree/master/jenkins/agent-base) is used as base image.

The image is built in the global `cd` project and is named `jenkins-agent-nodejs12`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-agent-nodejs12`.

```groovy
odsPipeline(
    image: "${dockerRegistry}/cd/jenkins-agent-nodejs12",
)
```

## Features

1. Nodes.js v12.x
2. npm / npx v6.x
3. yarn v1.X
4. Nexus configuration
5. HTTP Proxy awareness

## Known Limitations

**Coming from `jenkins-agent-nodejs10-angular`:**

There are no more any `angular`, `cypress` and/or `chrome` dependencies included - this is a plain `Node.js v12.x` jenkins agent! If you still need these requirements, you can create a customized jenkins agent and use `jenkins-agent-nodejs12` as base image.
