locals {
  name = "stack-azure-quickstarter-test"
}

module "stack-azure-quickstarter-test" {
  # module name and value of name parameter have to be equal
  source = "../../.."

  is_test          = true
  name             = local.name
  meta_environment = "DEVELOPMENT"
}
