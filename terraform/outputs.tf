output "resource_group_name" { value = data.azurerm_resource_group.rg.name }
output "app_service_plan" { value = azurerm_service_plan.asp.name }
output "app_service_name" { value = azurerm_linux_web_app.app.name }
output "acr_name" { value = azurerm_container_registry.acr.name }
output "acr_login_server" { value = azurerm_container_registry.acr.login_server }

# No admin creds outputs (admin is disabled)
