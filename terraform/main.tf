# Declarar la versión del Azure Resource Manager APIs.
# Tomarla del link: https://registry.terraform.io/providers/hashicorp/azurerm/latest

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}


# crea un service principal y rellena los siguientes datos para autenticar
provider "azurerm" {
  features {}
  subscription_id = "b1b164f1-7b71-44eb-999a-df58ac3010d6"
  client_id       = "aa297a9b-24d2-458c-b361-8ab4f60031a7"
  client_secret   = "OJ2.9Cetn84yDZ3u8gw-nqS_Ate7YSI.0D"
  tenant_id       = "899789dc-202f-44b4-8472-a6d40f9eb440"
}


# Creación del Resource Group

resource "azurerm_resource_group" "rg" {
    name     =  "kubernetes_rg"
    location = var.location

    tags = {
        environment = var.environment
    }

}

# Storage account
resource "azurerm_storage_account" "stAccountLmCp2" {
    name                     = var.storage_account
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = var.environment
    }

}