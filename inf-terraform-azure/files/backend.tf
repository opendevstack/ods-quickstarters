terraform {
  backend "azurerm" {
    container_name   = "tfstate"
    use_azuread_auth = true
  }
}
