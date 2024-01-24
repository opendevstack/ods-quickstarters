# Python end-to-end tests

This end-to-end testing project was generated from the *e2e-python* ODS quickstarter.

## Stages: installation / integration / acceptance

With the introduction of the release manager concept in OpenDevStack 3, e2e test quickstarters are expected to run tests in three different stages (installation, integration & acceptance) and generate a JUnit XML result file for each of these stages.

Make sure to keep `junit` as reporter and to not change the output path for the JUnit results files as they will be stashed by Jenkins and reused by the release manager.

## Running end-to-end tests

To execute all end-to-end tests:

1. Set up AWS account credentials in environment folder's yml files. 
2. Customize json files with the desired identification namings for the AWS resources that will be created with the quickestarters execution.
3. Modify the great_expectations and pytes folder to execute your tests located in the 'tests/acceptance/' directory.

# Pipeline execution options:
- By a commit with a change in the code the pipeline in jenkins will be automatically executed
- From jenkins manually
- Automatic from a test (create a function to automatize the trigger of the pipeline)

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
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name                                                                                                            | Description |
|-----------------------------------------------------------------------------------------------------------------|-------------|
| [modules\codebuild]()                                                                                           | resource    |
| [modules\codepipeline]()                                                                                        | resource    |
| [modules\iam_roles]()                                                                                           | resource    |
| [modules\s3-bucket]()                                                                                           | resource    |
| [modules\s3-bucket-policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource    |

## Resources

| Name                                                                                                                                       | Type |
|--------------------------------------------------------------------------------------------------------------------------------------------|------|
| [aws_codebuild_project.build_project](https://registry.terraform.io/providers/hashicorp/...)                                               | resource |
| [aws_codepipeline.codepipeline]()                                                                                                          | resource |
| [aws_iam_role.codepipeline_role]()                                                                                                         | resource |
| [aws_iam_role.codebuild_role]()                                                                                                            | resource |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                | resource |
| [aws_iam_role_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                   | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id) | resource |
| [aws_s3_bucket.codepipeline_bucket](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                      | resource |
| [aws_s3_bucket_versioning.s3versioning-cp](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)               | resource |
| [aws_s3_bucket.e2e_results_bucket](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                       | resource |
| [aws_s3_bucket_versioning.s3versioning-artfcs](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)           | resource |
| [aws_s3_bucket.source_bitbucket_bucket](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                  | resource |
| [aws_s3_bucket_versioning.s3versioning-bucket](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)           | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                                           | resource |
| [local_file.terraform-data](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/id)                              | resource |
| [time_static.deployment](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static)                              | resource |

## Inputs

| Name                                                                                                                         | Description                                                                                                             | Type | Default               | Required |
|------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|------|-----------------------|:--------:|
| <a name="input_codebuild_project_name"></a> [codebuild\_project\_name](#input\_codebuild\_project\_name)                     | The name of the AWS codebuild project.                                                                                  | `string` | `"codebuild-project"` | no |
| <a name="input_codepipeline_name"></a> [codepipeline\_name](#input\_codepipeline\_name)                                      | The name of the AWS codepipeline.                                                                                       | `string` | `"test-codepipeline"` | no |
| <a name="input_codepipeline_bucket_name"></a> [codepipeline\_bucket\_name](#input\_codepipeline\_bucket\_name)               | The name of the codepipeline artifacts S3 bucket.                                                                       | `string` | `"cpplartifacts"`     | no |
| <a name="input_bitbucket_source_bucket_name"></a> [bitbucket\_source\_bucket\_name](#input\_bitbucket\_source\_bucket\_name) | The name of the source S3 bucket.                                                                                       | `string` | `"src-bitbucket"`     | no |
| <a name="input_e2e_results_bucket_name"></a> [e2e\_results\_bucket\_name](#input\_e2e\_results\_bucket\_name)                | The name of the results S3 bucket.                                                                                      | `string` | `"test-results"`      | no |
| <a name="input_pipeline_role_name"></a> [pipeline\_role\_name](#input\_pipeline\_role\_name)                                 | The name of the codepipeline role.                                                                                      | `string` | `"test-codePipelineRole"`      | no |
| <a name="input_codebuild_role_name"></a> [codebuild\_role\_name](#input\_codebuild\_role\_name)                              | The name of the codebuild role.                                                                                         | `string` | `"test-codeBuildRole"`      | no |
| <a name="input_codepipeline_policy_name"></a> [codepipeline\_policy\_name](#input\_codepipeline\_policy\_name)               | The name of the codepipeline policy.                                                                                    | `string` | `"codepipeline_policy"`      | no |
| <a name="input_codebuild_policy_name"></a> [codebuild\_policy\_name](#input\_codebuild\_policy\_name)                        | The name of the codebuild policy.                                                                                       | `string` | `"codebuild_policy"`      | no |
| <a name="input_meta_environment"></a> [meta\_environment](#input\_meta\_environment)                                         | The type of the environment. Can be any of DEVELOPMENT, EVALUATION, PRODUCTIVE, QUALITYASSURANCE, TRAINING, VALIDATION. | `string` | `"DEVELOPMENT"`       | no |
| <a name="input_name"></a> [name](#input\_name)                                                                               | The name of the stack.                                                                                                  | `string` | `"stack-aws-quickstarter"` | no |

## Outputs

The output generated by terraform are used for internal quickestarter's purposes.


## Environments
The pipeline supports multiple environments (Testing/DEV/QA/PROD) within OpenDevStack. The behaviour of the pipeline in the environments can be controlled within the **environments** directory.
The *.yml files define the Jenkins secrets to read and are used to deploy into the right environments.
The *.json files can override variables from **variables.tf** in case different environments request different inputs (e.g. deploy a smaller version of the stack in DEV).

## Problems? Questions? Suggestions?

In case of problems, questions or suggestions, feel free to file an issue with the respective project's repository. Thanks!

