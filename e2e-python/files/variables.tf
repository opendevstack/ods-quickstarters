# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# This stack supports the following secrets as environment variables.
# -----------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION

# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# The following parameters require a value.
# Documentation: https://www.terraform.io/docs/configuration/variables.html
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# The following parameters are optional with sensible defaults.
# Documentation: https://www.terraform.io/docs/configuration/variables.html
# -----------------------------------------------------------------------------

variable "name" {
  description = "The name of the stack."
  type        = string
  default     = "stack-aws-quickstarter"
}

variable "meta_environment" {
  description = "The type of the environment. Can be any of DEVELOPMENT, EVALUATION, PRODUCTIVE, QUALITYASSURANCE, TRAINING, VALIDATION."
  type        = string
  default     = "DEVELOPMENT"
}


/*
# CodeBuild
variable "build_project_name" {}

# CodePipeline
variable "codepipeline_name" {}

# iam_roles
variable "pipeline_role_name" {}
variable "codebuild_role_name" {}
variable "codepipeline_policy_name" {}
variable "codebuild_policy_name" {}

# s3
variable "codepipeline_bucket_name" {}
variable "e2e_results_bucket_name" {}
variable "bitbucket_source_bucket_name" {}
*/

variable "projectId" {
  description = "EDP project name"
  type        = string
  default     = "testpg"
}

variable "environment" {
  description = "The project  execution environment."
  type        = string
  default     = "dev"
}

variable "repository" {
  description = "QS bitbucket repository"
  type        = string
  default = "e2e-python"
}

variable "branch_name" {
  description = "repository branch_name"
  type        = string
  default     = "master"
}
