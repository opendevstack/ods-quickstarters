locals {
  unique_name = var.name

  cf_stack_name = "cft-s3"

  tags = {
    BusinessApplicationName = upper(var.meta_business_application_name)
    DynamicResourceName     = upper(var.meta_dynamic_resource_name)
    ContactEmailAddress     = lower(var.meta_contact_email_address)
    Environment             = upper(var.meta_environment)
    StackId                 = local.id
    StackName               = lower(var.name)
    DeploymentDate          = formatdate("YYYYMMDD", timestamp())
    CostIdentifier          = "ProjectPhoenixCostTag"
  }
}

resource "aws_cloudformation_stack" "cft-s3" {
  name          = var.name
  template_body = file("${path.module}/cfn-templates/cfs3.json")
  tags          = local.tags
}


