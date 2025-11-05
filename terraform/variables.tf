variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "location" {
  description = "Azure location/region"
  type        = string
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
  default     = "team1-rg-auto"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "team1acrauto123"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = true
}

variable "app_service_plan_name" {
  description = "App Service Plan name"
  type        = string
  default     = "team1-asp-auto"
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU (B1/S1/P1v3 ...)"
  type        = string
  default     = "B1"
}

variable "app_service_name" {
  description = "Linux Web App name"
  type        = string
  default     = "team1-webapp-auto"
}

variable "enable_staging_slot" {
  description = "Create staging slot?"
  type        = bool
  default     = true
}
