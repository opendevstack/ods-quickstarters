locals {
  unique_name = var.name

  cf_stack_name = "cft-s3"

  tags = merge(local.common_tags, {
    DeploymentDate        = formatdate("YYYYMMDD", timestamp())
    InitialDeploymentDate = time_static.deployment.rfc3339
  })
}

resource "time_static" "deployment" {}

resource "aws_cloudformation_stack" "cft-s3" {
  name          = var.name
  template_body = file("${path.module}/cfn-templates/cfs3.json")
  tags          = local.tags
}


