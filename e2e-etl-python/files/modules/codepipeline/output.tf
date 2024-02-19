output "aws_codepipeline_arn" {
  value       = aws_codepipeline.codepipeline.arn
  description = "The ARN of the CodePipeline"
}

output "aws_codepipeline_id" {
  value       = aws_codepipeline.codepipeline.id
  description = "The id of the CodePipeline"
}

output "aws_codepipeline_name" {
  value       = aws_codepipeline.codepipeline.name
  description = "The name of the CodePipeline"
}
