locals {
  terraform-data = {
    id               = local.id
    name             = var.name
    tags             = local.tags
    data_bucket_name = var.data_bucket_name
    cf_stack_outputs = aws_cloudformation_stack.cft-s3.outputs
  }
}

resource "local_file" "terraform-data" {
  filename = "${path.module}/.terraform-data.json"
  content  = jsonencode(local.terraform-data)
}

