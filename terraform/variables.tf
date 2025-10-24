variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type = string
}

variable "resource_group_name" {
  description = "Existing RG"
  type        = string
  default     = "team1-rg-manual9"
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

