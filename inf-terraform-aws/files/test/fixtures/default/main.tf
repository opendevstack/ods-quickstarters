locals {
  name = "stack-aws-quickstarter-test"
  tags = {
    Name = local.name
  }
}

data "aws_region" "current" {}

module "stack-aws-quickstarter-test" {
  source = "../../.."

  name             = local.name
  meta_environment = "DEVELOPMENT"
}
