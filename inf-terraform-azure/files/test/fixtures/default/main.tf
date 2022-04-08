locals {
  name = "stack-azure-quickstarter-test"
}

module "stack-azure-quickstarter-test" {
  source = "../../.."

  is_test          = true
  name             = local.name
  meta_environment = "DEVELOPMENT"
}
