# ODS Prototype

This stack deploys a basic stack, consisting of a VPC, EC2, Security Groups, Endpoints and a keypair, for using as an OpenDevStack quickstarter.


## What is a Stack?

A stack is a useful combination of reusable [*blueprints*](https://bitbucket.biscrum.com/projects/INFIAAS) and infrastructure code, typically for the purpose of providing a digital product's technical fundament.

## How to use this Stack?

The behavior of a stack is determined by its purpose and the set of input parameters. Here is an overview of the *inputs* and *outputs* available for this stack.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| local | n/a |
| random | ~> 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| data\_bucket\_name | The name of the S3 data bucket. | `string` | `"bi-qs-demo-quicky"` | no |
| meta\_computer\_system\_name | The name of the computer system. | `string` | `"bi-cs-quickstarter"` | no |
| meta\_contact\_email\_address | An email address of a contact person. | `string` | `"changeme@boehringer-ingelheim.com"` | no |
| meta\_environment\_type | The type of the environment. Can be any of development, evaluation, productive, qualityassurance, training, or validation. | `string` | `"TEST"` | no |
| name | The name of the stack. | `string` | `"stack-aws-bi-quickstarter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| data\_bucket\_arn | The data S3 bucket ARN. |
| data\_bucket\_name | The data S3 bucket name. |
| meta\_computer\_system\_name | The name of the computer system. |
| meta\_contact\_email\_address | An email address of a contact person. |
| meta\_environment\_type | The type of the environment. |
| name | The name of the stack. |

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

Extending a stack basically involves adding more [blueprints](https://bitbucket.biscrum.com/projects/INFIAAS) whichever fit, and garnish it with custom infrastructure code if necessary.

Setting up stack development guardrails requires the following dependencies: `make`, `tee`, `ruby`, [`bundler`](https://bundler.io/), `python`, [`pre-commit`](https://pre-commit.com/) [`terraform`](https://www.terraform.io/), and [`terraform-docs`](https://github.com/segmentio/terraform-docs). Once installed, run `make install-dev-deps` to install a set of quality improving *pre-commit hooks* into your local Git repository. Upon a `git commit`, these hooks will make sure that your code is both syntactically and functionally correct and that your `README.md` contains up-to-date documentation of your stack's supported set of *inputs* and *outputs*.

More information on the development flow is available in [Confluence](https://confluence.biscrum.com/pages/viewpage.action?spaceKey=CPIS&title=Contribution+Guide).

## Problems? Questions? Suggestions?

In case of problems, questions or suggestions, feel free to file an issue with the respective project's repository. Thanks!

