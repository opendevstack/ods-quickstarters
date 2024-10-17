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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.114.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.114.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5.1 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.2 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.114.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group_template_deployment.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.114.0/docs/resources/resource_group_template_deployment) | resource |
| [local_file.terraform-data](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_static.deployment](https://registry.terraform.io/providers/hashicorp/time/0.12.0/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_is_test"></a> [is\_test](#input\_is\_test) | Whether whether it is part of a test execution or not. Defaults to false. | `bool` | `false` | no |
| <a name="input_meta_environment"></a> [meta\_environment](#input\_meta\_environment) | The type of the environment. Can be any of DEVELOPMENT, EVALUATION, PRODUCTIVE, QUALITYASSURANCE, TRAINING, VALIDATION. | `string` | `"DEVELOPMENT"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack. | `string` | `"stack-azure-quickstarter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arm_template_deployment_id"></a> [arm\_template\_deployment\_id](#output\_arm\_template\_deployment\_id) | The ID of the ARM deployment. |
| <a name="output_inputs2outputs"></a> [inputs2outputs](#output\_inputs2outputs) | all inputs passed to outputs |
| <a name="output_meta_environment"></a> [meta\_environment](#output\_meta\_environment) | The type of the environment. |
| <a name="output_name"></a> [name](#output\_name) | The name of the stack. |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | The ID of the resource group. |
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

