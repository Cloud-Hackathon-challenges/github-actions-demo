terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
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

# Use existing RG (data, not resource)
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "asp432"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
}

# ACR (admin disabled; MI will pull)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = false
}

# Linux Web App with System Assigned MI
resource "azurerm_linux_web_app" "app" {
  name                = "ass23847"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  identity { type = "SystemAssigned" }

  site_config {}

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "600"
  }
}

# AcrPull role assignment (keep only if your TF identity can create role assignments)
# If not, comment this out and do Option A above once via Owner user.
resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}

# Optional slot
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id
  site_config {}
}
