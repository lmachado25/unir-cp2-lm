# Declarar la versión del Azure Resource Manager APIs.
# Tomarla del link: https://registry.terraform.io/providers/hashicorp/azurerm/latest

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
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