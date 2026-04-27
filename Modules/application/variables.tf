variable "name_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_app_environment_id" {
  type = string
}

variable "acr_login_server" {
  type = string
}

variable "acr_username" {
  type = string
}

variable "acr_password" {
  type      = string
  sensitive = true
}

variable "api_image" {
  type = string
}

variable "site_image" {
  type = string
}

variable "db_connection_string" {
  type      = string
  sensitive = true
}

variable "redis_connection_string" {
  type      = string
  sensitive = true
}

variable "tags" {
  type = map(string)
}