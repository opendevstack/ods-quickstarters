terraform {
  backend "azurerm" {
    container_name   = "tfstate"
    key              = "terraform.tfstate"
    use_azuread_auth = true
  }
}
