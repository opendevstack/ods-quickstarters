resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.projectId}-e2e-s3-${var.aws_region}-${var.codepipeline_bucket_name}-${var.local_id}"
}
resource "aws_s3_bucket_versioning" "s3versioning-cp" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  versioning_configuration {
    status = var.s3_versioning_cp
  }
}

resource "aws_s3_bucket" "e2e_results_bucket" {
  bucket = "${var.projectId}-e2e-s3-${var.aws_region}-${var.e2e_results_bucket_name}-${var.local_id}"
}
resource "aws_s3_bucket_versioning" "s3versioning-artfcs" {
  bucket = aws_s3_bucket.e2e_results_bucket.id

  versioning_configuration {
    status = var.s3_versioning_results
  }
}

resource "aws_s3_bucket" "source_bitbucket_bucket" {
  bucket = "${var.projectId}-e2e-s3-${var.aws_region}-${var.bitbucket_source_bucket_name}-${var.local_id}"
}
resource "aws_s3_bucket_versioning" "s3versioning-bucket" {
  bucket = aws_s3_bucket.source_bitbucket_bucket.id

  versioning_configuration {
    status = var.s3_versioning_bitbuckets3
  }
}

