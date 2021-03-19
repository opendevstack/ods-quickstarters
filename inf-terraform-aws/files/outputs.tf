# -----------------------------------------------------------------------------
# OUTPUTS
# This stack supports the following output values.
# Documentation: https://www.terraform.io/docs/configuration/outputs.html
# -----------------------------------------------------------------------------

output "name" {
  description = "The name of the stack."
  value       = var.name
}

output "meta_business_application_name" {
  description = "The name of the business application system."
  value       = var.meta_business_application_name
}

output "meta_contact_email_address" {
  description = "An email address of a contact person."
  value       = var.meta_contact_email_address
}

output "meta_environment" {
  description = "The type of the environment."
  value       = var.meta_environment_type
}

output "meta_dynamic_resource_name" {
  description = "The name of the dynamic resource."
  value       = var.meta_dynamic_resource_name
}
