variable "pipeline_role_name" {
  description = "role_name"
  type        = string
  default     = "test-codePipelineRole"
}
variable "codebuild_role_name" {
  description = "role_name"
  type        = string
  default     = "test-codeBuildRole"
}

variable "codepipeline_policy_name" {
  description = "Codepipeline_policy_name"
  type        = string
  default     = "codepipeline_policy"
}
variable "codebuild_policy_name" {
  description = "Codebuild_policy_name"
  type        = string
  default     = "codebuild_policy"
}


variable "local_id" {
  description = "id for unique s3buckets "
  type        = string
}

variable "projectId" {
  description = "EDP project name"
  type        = string
}

variable "aws_region" {
  description = "AWS infrastructure region"
  type        = string
  default     = "eu-west-1"
}
