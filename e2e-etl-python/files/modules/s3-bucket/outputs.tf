output "cp_bucket_arn" {
  value       = aws_s3_bucket.codepipeline_bucket.arn
  description = "The ARN of the S3 Bucket"
}
output "cp_bucket_name" {
  value       = aws_s3_bucket.codepipeline_bucket.bucket
  description = "The Name of the S3 Bucket"
}
output "cp_bucket_id" {
  value       = aws_s3_bucket.codepipeline_bucket.id
  description = "The ID of the S3 Bucket"
}

output "e2e_results_bucket_arn" {
  value       = aws_s3_bucket.e2e_results_bucket.arn
  description = "The ARN of the results artifacts S3 Bucket"
}
output "e2e_results_bucket_name" {
  value       = aws_s3_bucket.e2e_results_bucket.bucket
  description = "The Name of the results artifacts S3 Bucket"
}
output "e2e_results_bucket_id" {
  value       = aws_s3_bucket.e2e_results_bucket.id
  description = "The ID of the results artifacts S3 Bucket"
}

output "bitbucket_s3bucket_arn" {
  value       = aws_s3_bucket.source_bitbucket_bucket.arn
  description = "The ARN of the bitbucket S3 Bucket"
}
output "bitbucket_s3bucket_name" {
  value       = aws_s3_bucket.source_bitbucket_bucket.bucket
  description = "The Name of the bitbucket S3 Bucket"
}
output "bitbucket_s3bucket_id" {
  value       = aws_s3_bucket.source_bitbucket_bucket.id
  description = "The ID of the bitbucket S3 Bucket"
}
