locals {
  unique_name = var.name

  cf_stack_name = "cft-s3"

  tags = {
    Computer-System-Name  = var.meta_computer_system_name
    Contact-Email-Address = var.meta_contact_email_address
    Environment-Type      = lower(var.meta_environment_type)
    Stack-ID              = local.id
    Stack-Name            = var.name
  }
}

resource "aws_cloudformation_stack" "cft-s3" {
  name          = var.name
  template_body = file("${path.module}/cfs3.json")
}


