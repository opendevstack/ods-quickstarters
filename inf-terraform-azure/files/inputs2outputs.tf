# This file has been created automatically.

output "inputs2outputs" {
  description = "all inputs passed to outputs"
  value = [{
    data_bucket_name = var.data_bucket_name
    meta_environment = var.meta_environment
    name             = var.name
  }]
}
