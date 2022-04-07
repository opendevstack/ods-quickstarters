locals {
  unique_name = var.is_test ? "${var.name}-${local.id}" : var.name
  location    = "westeurope"

  tags = merge(local.common_tags, {
    DeploymentDate        = formatdate("YYYYMMDD", timestamp())
    InitialDeploymentDate = time_static.deployment.rfc3339
  })
}

resource "time_static" "deployment" {}

resource "azurerm_resource_group" "this" {
  name     = local.unique_name
  location = local.location

  tags = local.tags
}

resource "azurerm_resource_group_template_deployment" "this" {
  name                = local.unique_name
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  template_content    = file("${path.module}/arm-templates/storage-account.json")

  tags = local.tags
}
