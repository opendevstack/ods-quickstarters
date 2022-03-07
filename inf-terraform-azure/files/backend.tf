 terraform {
  backend "azurerm" {
    resource_group_name  = "<resource-group>"
    storage_account_name = "<storage-account>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}
