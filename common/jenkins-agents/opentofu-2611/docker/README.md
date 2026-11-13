# OpenTofu Jenkins Agent

## Introduction
This jenkins agent is used to build, test and deploy AWS & Azure workloads in the cloud with OpenTofu.

It is `jenkins-agent-terraform-2408` without the Ruby stack, plus OpenTofu and Trivy at pinned versions.

The image is built in the global `ods` project and is named `jenkins-agent-opentofu-2611`. It can be referenced in a `Jenkinsfile` with `ods/jenkins-agent-opentofu-2611`.

## Pinned versions
| Tool | Version | Build argument | Installed to |
| --- | --- | --- | --- |
| OpenTofu | 1.12.5 | `TOFU_VERSION` | `/usr/local/bin/tofu` |
| Trivy | 0.69.3 | `TRIVY_VERSION` | `/usr/local/bin/trivy` |

Both are downloaded from their GitHub release and verified against the checksum file published with it.

The versions are recorded in the image labels `org.opendevstack.agent.tofu.version` and `org.opendevstack.agent.trivy.version`, and in `/etc/qs-agent/versions`.
They are not environment variables of the image: tenv reads `TOFU_VERSION`, and a Makefile that declares `TRIVY_VERSION ?= <version>` reads `TRIVY_VERSION`, so an exported value would replace the pin of the component being built.

## What the image contains
| Group | Tools |
| --- | --- |
| OpenTofu and Trivy | see "Pinned versions" |
| Terraform | Terraform 1.9.4 through tenv 3.0.0, tflint 0.52.0, terraform-docs v0.18.0, terraform-config-inspect 0.2.0, packer 1.11.2, consul 1.19.1 |
| Python | uv 0.13.5; Python 3.11 and 3.12, with `python3` being 3.12; the packages in `python_requirements` (boto3, requests, python-hcl2, pre-commit, pipenv, azure-cli and others), virtualenv and pycodestyle |
| Cloud CLIs | AWS CLI v2, AWS SAM CLI, aws-cdk, Azure CLI |
| Other | Node.js 24, Go 1.26.10, go-task 3.38.0, age 1.2.0, jq, parallel, and the build tools installed with dnf |

## What it leaves out compared with `jenkins-agent-terraform-2408`
- Ruby, rbenv, ruby-build and bundler
- the gems of the `Gemfile`: kitchen-terraform, Test Kitchen and cinc-auditor / InSpec
- the dnf packages only the Ruby build needed: `readline-devel` and `bison`

Everything else is the content of `jenkins-agent-terraform-2408` with the updates of [#1175](https://github.com/opendevstack/ods-quickstarters/pull/1175): Node.js 24, uv 0.13.5, Go 1.26.10, `python3` being Python 3.12, no Python 3.9, and refreshed CA stores.

## Self-test
The image contains `agent-selftest`. It checks the contract of the image and prints one `ok` or `FAIL` line per check:
OpenTofu and Trivy resolve from `/usr/local/bin` at the pinned versions, `python3` is 3.12 or newer and can import `hcl2`, `uv` finds Python 3.12 without a download, `terraform-docs`, `uv`, `aws`, `az`, `jq`, `make`, `git`, `bash`, `tar`, `curl` and `oc` are on `PATH`, the group id is 0 and `$HOME` is writable, `TOFU_VERSION` and `TRIVY_VERSION` are not set, and no Ruby tool is left.

It runs as the last step of the image build, so a build only succeeds when every check passes. In a pipeline it shows why a tool is missing or shadowed:

```groovy
sh 'agent-selftest'
```

`agent-selftest --expect-ca "<label>"` also requires that `trust list` contains a certificate with that label.

## Known limitations
Tests written for kitchen-terraform and InSpec cannot run on this agent. Components that use them, such as the ones created from the `inf-terraform-aws` and `inf-terraform-azure` quickstarters, need `jenkins-agent-terraform-2408`.
