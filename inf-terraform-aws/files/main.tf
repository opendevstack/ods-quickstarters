provider "aws" {
  version = "2.67"
}


locals {
  tags = {
    Computer-System-Name  = var.meta_computer_system_name
    Contact-Email-Address = var.meta_contact_email_address
    Environment-Type      = lower(var.meta_environment_type)
    Stack-ID              = local.id
    Stack-Name            = var.name
  }
}

# -------------------------------------
# S3 Bucket
# -------------------------------------
module "s3data" {
  source = "git::ssh://git@bitbucket.biscrum.com:7999/infiaas/blueprint-aws-s3.git?ref=v2.2.0"
  id     = local.id
  name   = var.data_bucket_name
  tags   = local.tags
}


