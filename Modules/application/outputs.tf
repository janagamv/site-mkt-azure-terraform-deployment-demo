output "api_internal_url" {
  value = "https://${azurerm_container_app.api.ingress[0].fqdn}"
}

output "site_url" {
  value = "https://${azurerm_container_app.site.ingress[0].fqdn}"
}