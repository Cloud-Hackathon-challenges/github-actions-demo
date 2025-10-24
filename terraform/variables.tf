variable "subscription_id" { type = string }
variable "client_id"       { type = string }
variable "client_secret"   { type = string  sensitive = true }
variable "tenant_id"       { type = string }

variable "resource_group_name" {
  description = "RG name to create/manage"
  type        = string
  default     = "team1-rg-manual9"
}

variable "resource_group_location" {
  description = "Azure region for the RG"
  type        = string
  default     = "northeurope"
}

variable "acr_name" {
  description = "ACR name"
  type        = string
  default     = "team1acrmanual9"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic" # or Standard
}

variable "acr_admin_enabled" {
  description = "Enable ACR admin user"
  type        = bool
  default     = true
}
