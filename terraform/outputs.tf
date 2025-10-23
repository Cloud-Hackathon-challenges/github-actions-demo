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
