variable "subscription_id" { type = string }
variable "client_id" { type = string }
variable "client_secret" { type = string }
variable "tenant_id" { type = string }

variable "resource_group_name" {
  type    = string
  default = "team1-rg-app"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "asp_name" {
  type    = string
  default = "asp-team1"
}

variable "acr_name" {
  type    = string
  default = "team1acrdev"
}

variable "acr_sku" {
  type    = string
  default = "Basic"
}

variable "acr_admin_enabled" {
  type    = bool
  default = true
}

variable "app_name" {
  type    = string
  default = "team1-webapp"
}

variable "slot1_name" {
  type    = string
  default = "slot1"
}
