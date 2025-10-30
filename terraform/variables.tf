variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID used by the provider"
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

variable "resource_group_name" {
  type        = string
  description = "Existing Resource Group name"
  default     = "team1-rg-manual6"
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name cannot be empty."
  }
}

variable "app_service_plan_name" {
  type        = string
  description = "Existing App Service Plan name (e.g., asp432)"
  validation {
    condition     = length(var.app_service_plan_name) > 0
    error_message = "app_service_plan_name is required."
  }
}

variable "app_service_name" {
  type        = string
  description = "Web App name to create (e.g., ass23847)"
  validation {
    condition     = length(var.app_service_name) > 0
    error_message = "app_service_name is required."
  }
}

variable "acr_name" {
  type        = string
  description = "Existing Azure Container Registry name"
  default     = "team1acrmanual6"
  validation {
    condition     = length(var.acr_name) > 0
    error_message = "acr_name cannot be empty."
  }
}

/* İsteğe bağlı: staging slot oluşturmayı kontrol etmek için
variable "enable_staging_slot" {
  type        = bool
  description = "Create a 'staging' deployment slot"
  default     = true
}
*/
