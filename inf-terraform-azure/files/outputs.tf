# -----------------------------------------------------------------------------
# OUTPUTS
# This stack supports the following output values.
# Documentation: https://www.terraform.io/docs/configuration/outputs.html
# -----------------------------------------------------------------------------

output "name" {
  description = "The name of the stack."
  value       = var.name
}

output "meta_environment" {
  description = "The type of the environment."
  value       = var.meta_environment
}

output "resource_group_id" {
  description = "The ID of the resource group."
  value       = azurerm_resource_group.this.id
}

output "arm_template_deployment_id" {
  description = "The ID of the ARM deployment."
  value       = azurerm_resource_group_template_deployment.this.id
}
