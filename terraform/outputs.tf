output "resource_group_name" {
  value = azurerm_resource_group.rg-registry.name
}

output "app_service_plan" {
  value = azurerm_service_plan.asp.name
}

output "app_service_name" {
  value = azurerm_linux_web_app.as.name
}

output "acr_name" {
  value = azurerm_container_registry.rcteamdev.name
}

output "acr_login_server" {
  value = azurerm_container_registry.rcteamdev.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.rcteamdev.admin_username
}

output "acr_admin_password" {
  value     = azurerm_container_registry.rcteamdev.admin_password
  sensitive = true
}  