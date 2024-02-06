locals {
  account_id = data.aws_caller_identity.current.account_id
  unique_name = var.name

  tags = merge(local.common_tags, {
    DeploymentDate        = formatdate("YYYYMMDD", timestamp())
    InitialDeploymentDate = time_static.deployment.rfc3339
  })
}

resource "time_static" "deployment" {}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "codebuild_terraform" {
  depends_on           = [ module.iam_roles ]
  source               = "./modules/codebuild"

#  build_project_name   = var.build_project_name
#  environment_type = var.environment_type
#  environment_image = var.environment_image
#  image_pull_credentials_type = var.image_pull_credentials_type
#  testing_project_name = var.testing_project_name

  codebuild_role_arn   = module.iam_roles.codebuild_role_arn
  codepipeline_bucket_name = module.s3_artifacts_bucket.cp_bucket_name
  e2e_results_bucket_name = module.s3_artifacts_bucket.e2e_results_bucket_name
  local_id = local.id
  projectId = var.projectId
  environment = var.environment
}

module "codepipeline_terraform" {

  source                 = "./modules/codepipeline"

#  codepipeline_name = var.codepipeline_name

  codepipeline_bucket_name = module.s3_artifacts_bucket.cp_bucket_name
  codepipeline_role_arn = module.iam_roles.codepipeline_role_arn
  bitbucket_source_bucket_name = module.s3_artifacts_bucket.bitbucket_s3bucket_name
  codebuild_project_name = module.codebuild_terraform.codebuild_project_name

  local_id = local.id
  projectId = var.projectId
  repository = var.repository
  branch_name = var.branch_name
}

module "iam_roles" {
  source                = "./modules/iam_roles"

#  pipeline_role_name    = var.pipeline_role_name
#  codebuild_role_name   = var.codebuild_role_name
#  codepipeline_policy_name  = var.codepipeline_policy_name
#  codebuild_policy_name = var.codebuild_policy_name

  local_id = local.id
  projectId = var.projectId
}

module "s3_artifacts_bucket" {
  source                  = "./modules/s3-bucket"

#  codepipeline_bucket_name     = var.codepipeline_bucket_name
#  bitbucket_source_bucket_name     = var.bitbucket_source_bucket_name
#  e2e_results_bucket_name     = var.codepipeline_bucket_name

  local_id = local.id
  projectId = var.projectId
}


