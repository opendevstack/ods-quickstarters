# ODS Azure Quickstarter

This Quickstarter can be used to deploy Azure resources. Its primary usage is to build a stack based on Terraform modules, but it also supports Azure RM templates, by wrapping these in Terraform resources.

## What is a Stack?

A stack is a useful combination of reusable modules or blueprints and infrastructure code, typically for the purpose of providing a digital product's technical fundament.

## How to use this Stack?

The behavior of a stack is determined by its purpose and the set of input parameters. Here is an overview of the *inputs* and *outputs* available for this stack.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | 3.0.2 |
| local | ~> 2.1.0 |
| random | ~> 3.1.0 |
| time | 0.7.2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 3.0.2 |
| local | ~> 2.1.0 |
| random | ~> 3.1.0 |
| time | 0.7.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azurerm_resource_group_template_deployment](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.2/docs/resources/resource_group_template_deployment) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.2/docs/resources/resource_group) |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/id) |
| [time_static](https://registry.terraform.io/providers/hashicorp/time/0.7.2/docs/resources/static) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| is\_test | Whether whether it is part of a test execution or not. Defaults to false. | `bool` | `false` | no |
| meta\_environment | The type of the environment. Can be any of DEVELOPMENT, EVALUATION, PRODUCTIVE, QUALITYASSURANCE, TRAINING, VALIDATION. | `string` | `"DEVELOPMENT"` | no |
| name | The name of the stack. | `string` | `"stack-azure-quickstarter-delete-me"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arm\_template\_deployment\_id | The ID of the ARM deployment. |
| inputs2outputs | all inputs passed to outputs |
| meta\_environment | The type of the environment. |
| name | The name of the stack. |
| resource\_group\_id | The ID of the resource group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to test this Stack?


Testing the functionality of this stack requires the following dependencies: `make`, `tee`, `ruby`, [`bundler`](https://bundler.io/), and [`terraform`](https://www.terraform.io/). Once installed, run `make test` from the command line.


Note that, when running tests, stacks will interact with some cloud provider, such as *AWS*, *Azure* or *VMware*. It is up to you to provide sufficient configuration to enable these interactions, which differs between vendors. Here is an example for *Azure* that uses environment variables (via [Get started with Azure CLI](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash?tabs=bash)):

```
$ export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$ export ARM_TENANT_ID="<azure_subscription_tenant_id>"
$ export ARM_CLIENT_ID="<service_principal_appid>"
$ export ARM_CLIENT_SECRET="<service_principal_password>"
$ make test
```

## How to extend a Stack?

Extending a stack basically involves adding more blueprints whichever fit, and garnish it with custom infrastructure code if necessary.

Setting up stack development guardrails requires the following dependencies: `make`, `tee`, `ruby`, [`bundler`](https://bundler.io/), `python`, [`pre-commit`](https://pre-commit.com/) [`terraform`](https://www.terraform.io/), and [`terraform-docs`](https://terraform-docs.io/). Once installed, run `make install-dev-deps` to install a set of quality improving *pre-commit hooks* into your local Git repository. Upon a `git commit`, these hooks will make sure that your code is both syntactically and functionally correct and that your `README.md` contains up-to-date documentation of your stack's supported set of *inputs* and *outputs*.

## Environments
The stack supports multiple environments (DEV/TEST/PROD) within OpenDevStack. The behaviour of the stack in the environments can be controlled within the **environments** directory.
The *.yml files define the Jenkins secrets to read and are used to deploy into the right environments.
The *.json files can override variables from **variables.tf** in case different environments request different inputs (e.g. deploy a different sized version of the stack in DEV).

## Problems? Questions? Suggestions?

In case of problems, questions or suggestions, feel free to file an issue with the respective project's repository. Thanks!

