# This file has been created automatically.
# terraform variables are passed to outputs.
# Following variable names are skipped: '.*[password|secret].*'.

output "inputs2outputs" {
  description = "all inputs passed to outputs"
  value = [{
    is_test          = var.is_test
    location         = var.location
    meta_environment = var.meta_environment
    name             = var.name
  }]
  sensitive = true
}
