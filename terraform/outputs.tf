output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "asp_name" {
  value = azurerm_service_plan.asp.name
}

output "app_name" {
  value = azurerm_linux_web_app.app.name
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}
