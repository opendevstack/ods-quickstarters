variable "codepipeline_name" {
  description = "the codepipeline name"
  type        = string
  default     = "test-codepipeline"
}

variable "codepipeline_bucket_name" {
  description = "s3_bucket_name"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the codepipeline IAM role"
  type        = string
}

variable "bitbucket_source_bucket_name" {
  description = "s3_source_bucket"
  type        = string
}

variable "artifacts_store_type" {
  description = "Artifacts store type"
  type        = string
  default     = "S3"
}

variable "source_provider" {
  description = "source_provider"
  type        = string
  default     = "S3"
}

variable "branch_name" {
  description = "branch_name"
  type        = string
  default     = "master"
}

variable "codebuild_project_name" {
  description = "codebuild project name"
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
  description = "AWS infrastructure region"
  type        = string
  default     = "eu-west-1"
}

variable "repository" {
  description = "QS bitbucket repository"
  type        = string
  default     = "e2e-python"
}
