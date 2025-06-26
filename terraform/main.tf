terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg-registry" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_container_registry" "rcteamdev" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg-registry.name
  location            = azurerm_resource_group.rg-registry.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

output "acr_name" {
  value = azurerm_container_registry.rcteamdev.name
}
