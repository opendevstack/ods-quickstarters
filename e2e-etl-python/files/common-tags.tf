locals {
  common_tags = {
    Environment = upper(var.meta_environment)
  }
}
