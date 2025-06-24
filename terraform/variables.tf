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

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "team1-rg-manual"
}

variable "resource_group_location" {
  description = "Location for the resource group"
  type        = string
  default     = "northeurope"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "team1acrmanual2"
}

variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Enable admin user for the ACR"
  type        = bool
  default     = true
}
