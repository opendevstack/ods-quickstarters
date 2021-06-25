# This file has been created automatically.

output "inputs2outputs" {
  description = "all inputs passed to outputs"
  value = [{
    data_bucket_name               = var.data_bucket_name
    meta_business_application_name = var.meta_business_application_name
    meta_contact_email_address     = var.meta_contact_email_address
    meta_dynamic_resource_name     = var.meta_dynamic_resource_name
    meta_environment               = var.meta_environment
    name                           = var.name
  }]
}
