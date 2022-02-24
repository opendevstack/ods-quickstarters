 terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-westeurope-dev-01-rg"
    storage_account_name = "edpprojectdevtfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}
