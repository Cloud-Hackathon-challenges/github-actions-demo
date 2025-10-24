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

# --- MEVCUT kaynaklar: sadece oku (silme/yeniden kurma yok) ---
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name   # ör: "asp432"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# --- YENİ oluşturulacaklar ---
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name        # ör: "ass23847"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = data.azurerm_service_plan.asp.id

  identity {
    type = "SystemAssigned"
  }

  site_config {}
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "600"
  }
}

# (İstersen) staging slot
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id
  site_config {}
}

# Web App’in Managed Identity’sine ACR pull izni
resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}
