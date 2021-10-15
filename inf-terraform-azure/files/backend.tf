terraform {
  backend "azurerm" {
    resource_group_name  = "<your resource group>"
    storage_account_name = "<your storage account>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}

