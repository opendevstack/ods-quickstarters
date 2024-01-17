variable "codebuild_project_name" {
  description = "codebuild project name"
  type        = string
  default     = "codebuild-project"
}

variable "codebuild_role_arn" {
  description = "Codebuild IAM role arn. "
  type        = string
}

variable "build_timeout" {
  description = "Build Timeout"
  type        = number
  default     = 60
}

variable "artifacts_type" {
  description = "type to store Artifacts"
  type        = string
  default     = "CODEPIPELINE"
}

variable "environment_compute_type" {
  description = "environment_compute_type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "environment_image" {
  description = "environment_image"
  type        = string
  default     = "aws/codebuild/standard:5.0"
}

variable "environment_type" {
  description = "environment_type"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "image_pull_credentials_type" {
  description = "image_pull_credentials_type"
  type        = string
  default     = "CODEBUILD"
}

variable "source_type" {
  description = "Artifacts_source_type"
  type        = string
  default     = "CODEPIPELINE"
}

variable "env_version" {
  type        = string
  default     = "3.9"
}

variable "report_build_status" {
  description = "report_build_status"
  type        = bool
  default     = false
}

variable "GXtest_project_name" {
  description = "codebuild Great Expectation project name"
  type        = string
  default     = "GXtest-project"
}
variable "GX_reporting_project_name" {
  description = "Great Expectations reporting project name"
  type        = string
  default     = "GX_reporting-project"
}
variable "Pytest_project_name" {
  description = "Pytest testing project name"
  type        = string
  default     = "Pytest-project"
}
variable "Pytest_reporting_project_name" {
  description = "Pytest reporting project name"
  type        = string
  default     = "Pytest_reporting-project"
}

variable "codepipeline_bucket_name" {
  description = "s3_bucket_name"
  type        = string
}

variable "e2e_results_bucket_name" {
  description = "s3_bucket_for_results_artifacts"
  type        = string
}

variable "local_id" {
  description = "id for unique s3buckets "
  type        = string
}

variable "projectId" {
  description = "EDP project name"
  type        = string
  default     = "testpg"
}

variable "aws_region" {
  description = "AWS infrastructure regio"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "The project  execution environment."
  type        = string
  default     = "dev"
}
