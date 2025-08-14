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

  lifecycle {
    prevent_destroy = true
    ignore_changes  = []
  }
}

resource "azurerm_service_plan" "asp" {
  name                = "asp432"
  location            = azurerm_resource_group.rg-registry.location
  resource_group_name = azurerm_resource_group.rg-registry.name
  sku_name            = "S1"
  os_type             = "Linux"
}

resource "azurerm_container_registry" "rcteamdev" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg-registry.name
  location            = azurerm_resource_group.rg-registry.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

resource "azurerm_linux_web_app" "as" {
  name                = "ass238471"
  resource_group_name = azurerm_resource_group.rg-registry.name
  location            = azurerm_resource_group.rg-registry.location
  service_plan_id     = azurerm_service_plan.asp.id
  site_config {}
}
resource "azurerm_app_service_slot" "slot1" {
  name                = "slot1"
  app_service_name    = azurerm_linux_web_app.as.name
  location            = azurerm_resource_group.rg-registry.location
  resource_group_name = azurerm_resource_group.rg-registry.name
  app_service_plan_id = azurerm_service_plan.asp.id
  site_config {
    always_on = true
  }
}
 