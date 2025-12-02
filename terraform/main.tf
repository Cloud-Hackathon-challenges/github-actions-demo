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

#---------------------------------------------------------
# Resource Group
#---------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#---------------------------------------------------------
# Azure Container Registry (ACR)
#---------------------------------------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"

  # IMPORTANT: Pipeline login yapabilsin
  admin_enabled       = true
}

#---------------------------------------------------------
# App Service Plan
#---------------------------------------------------------
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

#---------------------------------------------------------
# Web App with Multi-Container Support (Docker Compose)
#---------------------------------------------------------
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    # Compose file is passed by GitHub Actions deployment
    # Terraform only needs these settings
    application_stack {
      docker_image_name        = "DOCKER|compose"
      docker_image_tag         = "latest"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}

#---------------------------------------------------------
# Outputs for GitHub Actions
#---------------------------------------------------------

