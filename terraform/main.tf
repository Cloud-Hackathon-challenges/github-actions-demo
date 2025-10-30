# --- Create RG ---
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# --- Create ACR (admin enabled for convenience) ---
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# --- Create App Service Plan (Linux) ---
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

# --- Create Linux Web App with System-Assigned Identity ---
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  identity {
    type = "SystemAssigned"
  }

  site_config {}

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "600"
  }

  lifecycle {
    ignore_changes = [
      # We set the container via CLI with docker-compose in your workflow
      site_config
    ]
  }
}

# --- Optional staging slot ---
resource "azurerm_linux_web_app_slot" "staging" {
  count         = var.enable_staging_slot ? 1 : 0
  name          = "staging"
  app_service_id = azurerm_linux_web_app.app.id
  site_config {}
}

# --- Grant the Web App identity 'AcrPull' on the ACR ---
resource "azurerm_role_assignment" "app_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}
