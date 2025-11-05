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

# Auth: ARM_* env değişkenleri (CI veya local)
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
  sku_name            = var.app_service_plan_sku  # B1/S1/...
  os_type             = "Linux"
}

# Azure Container Registry (admin açık: workflow ACR cred kullanacak)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

# Linux Web App (SystemAssigned MI – RBAC vermiyoruz)
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  identity { type = "SystemAssigned" }

  site_config {
    always_on  = true
    ftps_state = "Disabled"
  }
}

