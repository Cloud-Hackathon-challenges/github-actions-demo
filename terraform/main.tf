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

# ------------------------------
# Resource Group
# ------------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  lifecycle {
    prevent_destroy = true
  }
}

# ------------------------------
# App Service Plan (Linux)
# ------------------------------
resource "azurerm_service_plan" "asp" {
  name                = "asp432"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

# ------------------------------
# Azure Container Registry (ACR)
# ------------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = false           # MSI ile çekeceğiz; admin user KAPALI
}

# ------------------------------
# Linux Web App + System Assigned Identity
# ------------------------------
resource "azurerm_linux_web_app" "app" {
  name                = "ass238471"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  # MSI (şifresiz ACR pull için gerekli)
  identity {
    type = "SystemAssigned"
  }

  # Multi-container için kritik ayarlar
  app_settings = {
    WEBSITES_PORT                       = "80"     # edge container 80 dinliyor
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "1200"
  }

  site_config {
    always_on = true
  }
}

# (İsteğe bağlı) Deployment slot; istersen kullanmaya devam et
resource "azurerm_app_service_slot" "slot2" {
  name                = "slot2"
  app_service_name    = azurerm_linux_web_app.app.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.asp.id

  site_config {
    always_on = true
  }
}

# ------------------------------
# Web App MSI'ına ACR üzerinde AcrPull rolü
# ------------------------------
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id

  depends_on = [
    azurerm_linux_web_app.app,
    azurerm_container_registry.acr
  ]
}
