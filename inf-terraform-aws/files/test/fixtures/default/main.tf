locals {
  name = "stack-aws-quickstarter-test"
  tags = {
    Name = local.name
  }
}

data "aws_region" "current" {}

module "stack-aws-quickstarter-test" {
  source = "../../.."

  name = local.name

  meta_computer_system_name  = "Project Phoenix"
  meta_contact_email_address = "changeme@phoenix.com"
  meta_environment_type      = "evaluation"

}
