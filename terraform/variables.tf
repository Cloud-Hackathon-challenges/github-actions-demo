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
  type    = string
  default = "team1-rg-auto"
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "acr_name" {
  type    = string
  default = "team1acrauto123"
}

variable "app_service_plan_name" {
  type    = string
  default = "team1-asp-auto"
}

variable "app_service_plan_sku" {
  type    = string
  default = "F1"
}

variable "app_service_name" {
  type    = string
  default = "team1-webapp-auto"
}
