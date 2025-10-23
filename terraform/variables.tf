# ---- Auth (Service Principal) ----
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

# ---- Common ----
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "team1-rg-manual9"
}

variable "resource_group_location" {
  description = "Location for the resource group"
  type        = string
  default     = "northeurope"
}

# ---- ACR ----
variable "acr_name" {
  description = "Azure Container Registry name (globally unique, alnum)"
  type        = string
  default     = "team1acrmanual9"
}

variable "acr_sku" {
  description = "ACR SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}
