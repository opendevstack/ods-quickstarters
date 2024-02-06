# Python end-to-end tests

This is a python based quicktarter intended to develop end-to-end tests for data pipelines.
In order to do that it uses two testing technologies: 
  1. Great Expectations, meant for data transformation testing data within relational tables.
     e.g.: You could test the schema of a database, the number of rows, that a specific column has no null values, etc
  2. Pytest together with Boto it allows for testing etl triggers, notification system, content of S3 buckets, etc

This quickstarter project was generated from the *inf-terraform-aws* ODS quickstarter.

How it works:
   1. The ODS Jenkins pipeline starts.
   2. It compresses the bitbucket repository containing the tests, and it places it in an S3 bucket into the AWS account specified.
   3. In AWS it creates and trigger a code pipeline that will execute the tests.
   4. When the AWS code pipeline finish, it creates the necessary reports and sends them back to Jenkins.
   5. The Jenkins pipeline finish when receiving the reports.
  


## Stages: installation / integration / acceptance

With the introduction of the release manager concept in OpenDevStack 3, e2e test quickstarters are expected to run tests in three different stages (installation, integration & acceptance) and generate a JUnit XML result file for each of these stages.

Make sure to keep `junit` as reporter and to not change the output path for the JUnit results files as they will be stashed by Jenkins and reused by the release manager.

## How to prepare data
In case that you need to prepare data before the execution of your Great Expecations tests you could use the test_preparation folder, that contains the pre_requisites.py and post_requisites.py, these scripts
will be executed before and after the execution of your Great Expectations tests.

In the pre_requistes.py  you can do things such as prepare your data sets, create temporally resources... or even trigger your ETL pipelines.
After the execution of your Great Expectations test, the post_requisites.py will be executed. It is intended to be used as a clean-up step  to remove any data set, 
or reset your system to its initial state.

For pytest you can configure pre and post requistes on your own since it's much more flexible than Great Expectations.
The tests will be executed in this order:
  1. pre_requistes.py
  2. Great Expecations test suite
  3. post_requistes.py
  4. Pytest test suite

## Running end-to-end tests

To execute all end-to-end tests:

1. Set up AWS account credentials in environment folder's yml files. 
2. Customize json files with the desired identification namings for the AWS resources that will be created with the quickestarters execution.
3. Modify the great_expectations and pytes folder to execute your tests located in the 'tests/acceptance/' directory.

# Pipeline execution options
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
| <a name="requirement_great_expectations"></a> [great_expectations](#requirement\_great_expectations) | 0.18.3 |
| <a name="requirement_pytest"></a> [pytest](#requirement\_pytest) | 7.4.3 |
| <a name="requirement_boto3"></a> [boto3](#requirement\_boto3) | 1.29.6 |
| <a name="requirement_allure-pytest"></a> [allure-pytest](#requirement\_allure-pytest) | 2.13.2 |
| <a name="requirement_allure-combine"></a> [allure-combine](#requirement\_allure-combine) | 1.0.11 |


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
The pipeline supports multiple environments (DEV/QA/PROD) within OpenDevStack. The behaviour of the pipeline in the environments can be controlled within the **environments** directory.
The *.yml files define the Jenkins secrets to read and are used to deploy into the right environments.
The *.json files can override variables from **variables.tf** in case different environments request different inputs (e.g. deploy a smaller version of the stack in DEV).

## Problems? Questions? Suggestions?

In case of problems, questions or suggestions, feel free to file an issue with the respective project's repository. Thanks!

