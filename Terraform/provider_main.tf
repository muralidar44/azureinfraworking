 terraform {
   required_version = ">=0.12"
   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
 }

 provider "azurerm" {
   features {}

  subscription_id = "49db0cbb-ac2c-4caa-b82b-39b1426c634d"
  client_id       = "7e661f12-b6ab-443a-a439-098b2700ae2f"
  client_secret   = "tJm8Q~rsLC2UruuZi8.ewAcTgr1.nuOzstJbMdrN"
  tenant_id       = "c7e8dde8-5811-4ad2-bc91-f0e957a0ca3e"

 }
