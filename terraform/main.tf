terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "team1tfstate-rg"
    storage_account_name = "team1tfstateacct"
    container_name       = "tfstate"
    key                  = "team1/infra.tfstate"
  }
}

# Auth: ARM_* env değişkenleri (CI’de secrets) ile gelir
provider "azurerm" {
  features {}
}

# ---------- Resources ----------

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  lifecycle {
    prevent_destroy = true
    ignore_changes  = []
  }
}

# App Service Plan (Linux)
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.app_service_plan_sku
  os_type             = "Linux"
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

# Linux Web App (SystemAssigned Managed Identity)
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  identity { type = "SystemAssigned" }

  site_config {
    # Docker compose deploy'u workflow'da az cli ile yapılacak.
  }
}

# (Opsiyonel) Staging slot (flag ile kontrol)
resource "azurerm_linux_web_app_slot" "slot" {
  count          = var.enable_staging_slot ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {}
}

# Web App MI -> ACR Pull yetkisi
resource "azurerm_role_assignment" "acr_pull_for_app" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}
