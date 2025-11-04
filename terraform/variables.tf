variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}
variable "client_id" {
  type        = string
  description = "Azure AD application (client) ID"
}
variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Azure AD application client secret"
}
variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "location" {
  type        = string
  description = "Azure region (e.g., westeurope, northeurope)"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name to create/use"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name to create"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service Plan name to create one"
}

variable "app_service_plan_sku" {
  type        = string
  description = "App Service Plan SKU (e.g., B1, P1v3)"
  default     = "B1"
}

variable "app_service_name" {
  type        = string
  description = "Linux Web App name to create"
}

# Optional: create staging slot
variable "enable_staging_slot" {
  type        = bool
  description = "Create a 'staging' slot"
  default     = true
}
