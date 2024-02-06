locals {
  terraform-data = {
    id             = local.id
    name           = var.name
    tags           = local.tags
    current_region = data.aws_region.current.name
  }
}

resource "local_file" "terraform-data" {
  filename = "${path.module}/.terraform-data.json"
  content  = jsonencode(local.terraform-data)
}

