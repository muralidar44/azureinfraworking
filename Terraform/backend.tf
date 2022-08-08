# Define Terraform provider

 terraform {
   required_version = ">=0.12"
  backend "azurerm" {
    resource_group_name  = "tstate-rg"
    storage_account_name = "tfstr8811"
    container_name       = "tfstate"
    key                  = "W0q2+9GdV0Dh9Hjy3uGIK49RWnhYy9D3/kpvEtPD+ENt9ghTQqWz07zwDyXKy4HGkc+D1EYH3iAk+AStfV6zGw=="
  }
}
# Configure the Azure provider
 provider "azurerm" { 
  environment = "public"
}