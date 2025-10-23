output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource Group name"
}

output "app_service_plan" {
  value       = azurerm_service_plan.asp.name
  description = "App Service Plan name"
}

output "app_service_name" {
  value       = azurerm_linux_web_app.app.name
  description = "Linux Web App name"
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "ACR name"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "ACR login server FQDN"
}
