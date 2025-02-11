variable "codepipeline_bucket_name" {
  type = string
  default = "cpplartifacts"
}

variable "bitbucket_source_bucket_name" {
  description = "Source bitbucket s3 bucket name"
  type = string
  default = "src-bitbucket"
}

variable "e2e_results_bucket_name" {
  description = "s3_bucket_for_results_artifacts"
  type        = string
  default = "test-results"
}

variable "s3_versioning_cp" {
  description = "s3 versioning for codepipeline bucket"
  type        = string
  default     = "Enabled"
}

variable "s3_versioning_bitbuckets3" {
  description = "s3 versioning for source bucket"
  type        = string
  default     = "Enabled"
}

variable "s3_versioning_results" {
  description = "s3 versioning for results bucket"
  type        = string
  default     = "Enabled"
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
