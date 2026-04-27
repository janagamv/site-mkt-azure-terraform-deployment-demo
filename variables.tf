variable "project" {
  type    = string
  default = "site-mkt"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "canadacentral"
}

variable "location_short" {
  type    = string
  default = "cac"
}

variable "deploy_application" {
  type    = bool
  default = false
}

variable "sql_admin_username" {
  type    = string
  default = "siteadmin"
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "api_image" {
  type    = string
  default = "acrsitemktdevcac.azurecr.io/site-mkt-marketing-api:v1"
}

variable "site_image" {
  type    = string
  default = "acrsitemktdevcac.azurecr.io/site-mkt-marketing-site:v1"
}