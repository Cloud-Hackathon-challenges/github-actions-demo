output "resource_group_name" {
  value = azurerm_resource_group.rg-registry.name
}

output "app_service_plan" {
  value = azurerm_service_plan.asp.name
}

output "app_service_name" {
  value = azurerm_linux_web_app.as.name
}
