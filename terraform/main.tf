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

# RG zaten var (data kaynağıyla okuyoruz)
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "asp432"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

# ACR
resource "azurerm_container_registry" "rcteamdev" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

# Linux Web App
resource "azurerm_linux_web_app" "as" {
  name                = "ass23847"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {}
}

# Slot (Linux için doğru kaynak)
resource "azurerm_linux_web_app_slot" "slot2" {
  name           = "slot2"
  app_service_id = azurerm_linux_web_app.as.id

  site_config {
    always_on = true
  }
}
