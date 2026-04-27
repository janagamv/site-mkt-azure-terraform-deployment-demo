output "name_prefix" {
  value = local.name_prefix
}

output "tags" {
  value = local.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.main.admin_username
}

output "acr_admin_password" {
  value     = azurerm_container_registry.main.admin_password
  sensitive = true
}

output "container_app_environment_id" {
  value = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  value = azurerm_container_app_environment.main.name
}

output "db_connection_string" {
  value     = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive = true
}

output "redis_connection_string" {
  value     = azurerm_redis_cache.main.primary_connection_string
  sensitive = true
}