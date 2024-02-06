
provider "aws" {
  region = var.aws_region
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.projectId}-e2e-cppl-${var.aws_region}-${var.codepipeline_name}-${var.local_id}"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = var.artifacts_store_type
    location = var.codepipeline_bucket_name
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = var.source_provider
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        S3Bucket             = var.bitbucket_source_bucket_name
        S3ObjectKey          = "${var.repository}-${var.branch_name}.zip"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Test"

    action {
      name             = "Test"
      category         = "Build"
      provider         = "CodeBuild"
      owner            = "AWS"
      input_artifacts  = ["source_output"]
      output_artifacts = ["install_output"]
      version          = "1"
      configuration    = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}



