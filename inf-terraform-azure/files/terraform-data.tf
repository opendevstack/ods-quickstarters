locals {
  terraform-data = {
    id   = local.id
    name = var.name
    tags = local.tags

    resource_group_id          = azurerm_resource_group.this.id
    arm_template_deployment_id = azurerm_resource_group_template_deployment.this.id
  }
}

resource "local_file" "terraform-data" {
  filename = "${path.module}/.terraform-data.json"
  content  = jsonencode(local.terraform-data)
}
