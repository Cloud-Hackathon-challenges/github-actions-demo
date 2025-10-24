output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "app_service_plan" {
  value = data.azurerm_service_plan.asp.name
}

# Eğer ismi değişkenle veriyorsan:
output "app_service_name" {
  value = var.app_service_name
  # Alternatif: değer kaynaktan gelsin istiyorsan
  # value = azurerm_linux_web_app.app.name
}

output "acr_name" {
  value = data.azurerm_container_registry.acr.name
}

output "acr_login_server" {
  value = data.azurerm_container_registry.acr.login_server
}

# ACR admin kapalıysa aşağıdakiler boş/uygunsuz olabilir; MI ile pull yapacağız zaten.
output "acr_admin_username" {
  value = try(data.azurerm_container_registry.acr.admin_username, "")
}

output "acr_admin_password" {
  value     = try(data.azurerm_container_registry.acr.admin_password, "")
  sensitive = true
}

# İstersen web app’in default hostname’i de (attribute adı 'default_hostname')
# output "app_default_hostname" {
#   value = azurerm_linux_web_app.app.default_hostname
# }
