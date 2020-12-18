output "inputs2outputs" {
  description = "all inputs passed to outputs"
  value = [{
    data_bucket_name           = var.data_bucket_name
    meta_computer_system_name  = var.meta_computer_system_name
    meta_contact_email_address = var.meta_contact_email_address
    meta_environment_type      = var.meta_environment_type
    name                       = var.name
  }]
}
