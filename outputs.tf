output "resource_group_name" {
  value = module.landing_zone.resource_group_name
}

output "acr_name" {
  value = module.landing_zone.acr_name
}

output "acr_login_server" {
  value = module.landing_zone.acr_login_server
}

output "container_app_environment_name" {
  value = module.landing_zone.container_app_environment_name
}

output "site_url" {
  value = var.deploy_application ? module.application[0].site_url : null
}

output "api_internal_url" {
  value = var.deploy_application ? module.application[0].api_internal_url : null
}