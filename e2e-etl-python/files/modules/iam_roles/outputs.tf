output "codepipeline_role_arn" {
  value       = try(aws_iam_role.codepipeline_role.arn, "")
  description = "role arn"
}

output "codebuild_role_arn" {
  value       = try(aws_iam_role.codebuild_role.arn, "")
  description = "role arn"
}


