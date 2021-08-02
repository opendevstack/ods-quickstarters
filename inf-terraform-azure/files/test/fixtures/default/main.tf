locals {
  name = "stack-azure-quickstarter-test"
  tags = {
    Name = local.name
  }
}

module "stack-azure-quickstarter-test" {
  source = "../../.."

  name             = local.name
  meta_environment = "DEVELOPMENT"
}
