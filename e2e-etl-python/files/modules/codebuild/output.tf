output "codebuild_project_name" {
  value       = aws_codebuild_project.build_project.name
  description = "Name of the CodeBuild project"
}
output "codebuild_project_arn" {
  value       = aws_codebuild_project.build_project.arn
  description = "ARN of the CodeBuild project"
}
output "codebuild_project_id" {
  value       = aws_codebuild_project.build_project.id
  description = "ID of the CodeBuild project"
}
