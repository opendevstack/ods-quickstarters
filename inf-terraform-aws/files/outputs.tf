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
