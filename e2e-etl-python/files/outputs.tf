# -----------------------------------------------------------------------------
# OUTPUTS
# This stack supports the following output values.
# Documentation: https://www.terraform.io/docs/configuration/outputs.html
# -----------------------------------------------------------------------------

output "name" {
  description = "The name of the stack."
  value       = var.name
}

output "meta_environment" {
  description = "The type of the environment."
  value       = var.meta_environment
}

output "aws_region" {
  description = "The current region."
  value       = data.aws_region.current.name
}


output "codebuild_name" {
  value       = module.codebuild_terraform.codebuild_project_name
  description = "The Name of the Codebuild Project"
}
output "codebuild_arn" {
  value       = module.codebuild_terraform.codebuild_project_arn
  description = "The ARN of the Codebuild Project"
}

output "codepipeline_name" {
  value       = module.codepipeline_terraform.aws_codepipeline_name
  description = "The Name of the CodePipeline"
}
output "codepipeline_arn" {
  value       = module.codepipeline_terraform.aws_codepipeline_arn
  description = "The ARN of the CodePipeline"
}

output "cp_iam_arn" {
  value       = module.iam_roles.codepipeline_role_arn
  description = "The ARN of the IAM Role used by the CodePipeline"
}
output "cb_iam_arn" {
  value       = module.iam_roles.codebuild_role_arn
  description = "The ARN of the IAM Role used by the CodePipeline"
}

output "bitbucket_s3bucket_name" {
  value       = module.s3_artifacts_bucket.bitbucket_s3bucket_name
  description = "The Name of the bitbucket S3 Bucket"
}
output "cp_bucket_name" {
  value       = module.s3_artifacts_bucket.cp_bucket_name
  description = "The Name of the S3 Bucket"
}
output "e2e_results_bucket_name" {
  value       = module.s3_artifacts_bucket.e2e_results_bucket_name
  description = "The Name of the results artifacts S3 Bucket"
}
