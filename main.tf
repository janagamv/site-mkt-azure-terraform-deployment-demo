module "landing_zone" {
  source = "./modules/landing_zone"

  project            = var.project
  environment        = var.environment
  location           = var.location
  location_short     = var.location_short
  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password
}

module "application" {
  count  = var.deploy_application ? 1 : 0
  source = "./modules/application"

  name_prefix                  = module.landing_zone.name_prefix
  resource_group_name          = module.landing_zone.resource_group_name
  container_app_environment_id = module.landing_zone.container_app_environment_id

  acr_login_server = module.landing_zone.acr_login_server
  acr_username     = module.landing_zone.acr_admin_username
  acr_password     = module.landing_zone.acr_admin_password

  api_image  = var.api_image
  site_image = var.site_image

  db_connection_string    = module.landing_zone.db_connection_string
  redis_connection_string = module.landing_zone.redis_connection_string

  tags = module.landing_zone.tags
}