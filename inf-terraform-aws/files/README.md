# ODS AWS Quickstarter

This Quickstarter can be used to deploy AWS resources. Its primary usage is to build a stack based on Terraform modules, but it also supports Cloudformation (native or built using AWS SAM), by wrapping it in Terraform resource.

## What is a Stack?

A stack is a useful combination of reusable modules or blueprints and infrastructure code, typically for the purpose of providing a digital product's technical fundament.

## How to use this Stack?

The behavior of a stack is determined by its purpose and the set of input parameters. Here is an overview of the *inputs* and *outputs* available for this stack.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.67.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | git::https://bitbucket.biscrum.com/scm/infiaas/blueprint-aws-s3.git | v6.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.cft-s3](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/cloudformation_stack) | resource |
| [local_file.terraform-data](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id) | resource |
| [time_static.deployment](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [aws_iam_policy_document.read_and_write_bucket](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_bucket_name"></a> [data\_bucket\_name](#input\_data\_bucket\_name) | The name of the S3 data bucket. | `string` | `"quickstarter"` | no |
| <a name="input_meta_environment"></a> [meta\_environment](#input\_meta\_environment) | The type of the environment. Can be any of DEVELOPMENT, EVALUATION, PRODUCTIVE, QUALITYASSURANCE, TRAINING, VALIDATION. | `string` | `"DEVELOPMENT"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the stack. | `string` | `"stack-aws-quickstarter"` | no |
| <a name="input_s3_bucket_versioning"></a> [s3\_bucket\_versioning](#input\_s3\_bucket\_versioning) | Setup the bucket versioning to be Enabled, Suspended, or Disabled. | `string` | `"Enabled"` | no |
| <a name="input_s3_force_destroy"></a> [s3\_force\_destroy](#input\_s3\_force\_destroy) | Defines if all objects in the bucket shall be destroyed so that the bucket can be deleted, or not (true for testing). | `bool` | `true` | no |
| <a name="input_s3_name"></a> [s3\_name](#input\_s3\_name) | The name of the S3 bucket. | `string` | `"chooseanameforthebucket"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_inputs2outputs"></a> [inputs2outputs](#output\_inputs2outputs) | all inputs passed to outputs |
| <a name="output_meta_environment"></a> [meta\_environment](#output\_meta\_environment) | The type of the environment. |
| <a name="output_module_blueprint_aws_s3"></a> [module\_blueprint\_aws\_s3](#output\_module\_blueprint\_aws\_s3) | n/a |
| <a name="output_name"></a> [name](#output\_name) | The name of the stack. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the s3 bucket. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The ID of the s3 bucket. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to test this Stack?


Testing the functionality of this stack requires the following dependencies: `make`, `tee`, `ruby`, [`bundler`](https://bundler.io/), and [`terraform`](https://www.terraform.io/). Once installed, run `make test` from the command line.

Note that, when running tests, stacks will interact with some cloud provider, such as *AWS*, *Azure* or *VMware*. It is up to you to provide sufficient configuration to enable these interactions, which differs between vendors. Here is an example for *AWS* that uses environment variables (via [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)):

```
$ export AWS_ACCESS_KEY_ID=...
$ export AWS_SECRET_ACCESS_KEY=...
$ export AWS_DEFAULT_REGION=us-east-1
$ make test
```

## How to extend a Stack?

Extending a stack basically involves adding more blueprints whichever fit, and garnish it with custom infrastructure code if necessary.

Setting up stack development guardrails requires the following dependencies: `make`, `tee`, `ruby`, [`bundler`](https://bundler.io/), `python`, [`pre-commit`](https://pre-commit.com/) [`terraform`](https://www.terraform.io/), and [`terraform-docs`](https://github.com/segmentio/terraform-docs). Once installed, run `make install-dev-deps` to install a set of quality improving *pre-commit hooks* into your local Git repository. Upon a `git commit`, these hooks will make sure that your code is both syntactically and functionally correct and that your `README.md` contains up-to-date documentation of your stack's supported set of *inputs* and *outputs*.

## Environments
The stack supports multiple environments (testing/DEV/QA/PROD) within OpenDevStack. The behaviour of the stack in the environments can be controlled within the **environments** directory.
The *.yml files define the Jenkins secrets to read and are used to deploy into the right environments.
The *.json files can override variables from **variables.tf** in case different environments request different inputs (e.g. deploy a smaller version of the stack in DEV).

## Verify Configuration
Runing `make check-config` will do a basic verification on the stack setup and provides hints what is missing. Once the output only includes `Passed` or `Warn` results, you are ready to go deploying the Quickstarter within ODS.

```
$ make check-config
Account "XXXXXXXXXXXX" is configured for the dev environment...........Passed
There is no account configured for the test environment................ Warn
There is no account configured for the prod environment................ Warn
AWS account configured using SSO.........................................Passed
  Using "YYYYYYYYYYYYYY:ZZZZZZZZ@MyOrganization.com".....................Passed
Backend configured to "MyStateFileLocation"..............................Passed
  Check account can write to bucket......................................Passed
```
## Problems? Questions? Suggestions?

In case of problems, questions or suggestions, feel free to file an issue with the respective project's repository. Thanks!

