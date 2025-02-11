# Terraform Jenkins Agent

## Introduction
This jenkins agent is used to build and deploy AWS & Azure workloads in the cloud.

The image is built in the global `ods` project and is named `jenkins-agent-terraform-2408`. It can be referenced in a `Jenkinsfile` with `ods/jenkins-agent-terraform-2408`.

## Known limitations
Kitchen-terraform is approaching EOL but inspec is still a supported tool.
