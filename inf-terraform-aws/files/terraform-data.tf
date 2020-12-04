locals {
  terraform-data = {
    id               = local.id
    name             = var.name
    tags             = local.tags
    data_bucket_name = var.data_bucket_name
  }
}

resource "local_file" "terraform-data" {
  filename = "${path.module}/.terraform-data.json"
  content  = jsonencode(local.terraform-data)
}

