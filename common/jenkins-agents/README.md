# Jenkins agents

Hosts all the jenkins agents that are part of the OpenDevStack distribution.

All these agents inherit from the [agent-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/agent-base), and are built in the global `CD` project.

Inside your `jenkinsfile` you can configure which agent is used by changing the `image` property to your imagestream (e.g. in case it's in a `project`-cd namespace and not in the global `CD` one).

```groovy
odsPipeline(
  image: "<dockerRegistry>/<namespace>/jenkins-agent-jdk:<tag>"
```

The ODS [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library) takes care about starting the `jenkins agent` during the build as pod in your `project`s `cd` namespace with the `jenkins` service account.

## Currently Available agents

1. [GoLang](golang)
2. [Jdk](jdk)
3. [Node.js 16](nodejs16)
4. [Node.js 18](nodejs18)
5. [Node.js 20](nodejs20)
6. [Python](python)
7. [Rust](rust)
8. [Scala & SBT](scala)
9. [Terraform](terraform)
10. [Terraform 2306](terraform-2306)
11. [Terraform 2408](terraform-2408)

## OCP Config / Installation

Config can be created / updated / deleted with Tailor.

Example:

```sh
cd <agent name>/ocp-config && tailor status
```
