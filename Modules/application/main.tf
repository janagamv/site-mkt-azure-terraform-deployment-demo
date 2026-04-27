resource "azurerm_container_app" "api" {
  name                         = "${var.name_prefix}-api-ca"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  registry {
    server               = var.acr_login_server
    username             = var.acr_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.acr_password
  }

  secret {
    name  = "db-connection-string"
    value = var.db_connection_string
  }

  ingress {
    external_enabled = false
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "api"
      image  = var.api_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "DB_CONNECTION_STRING"
        secret_name = "db-connection-string"
      }
    }
    min_replicas = 0
    max_replicas = 2
  }
}

resource "azurerm_container_app" "site" {
  name                         = "${var.name_prefix}-site-ca"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  registry {
    server               = var.acr_login_server
    username             = var.acr_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.acr_password
  }

  secret {
    name  = "redis-connection-string"
    value = var.redis_connection_string
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "site"
      image  = var.site_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "REDIS_CONNECTION_STRING"
        secret_name = "redis-connection-string"
      }

      env {
        name  = "MarketingApi__BaseUrl"
        value = "https://${azurerm_container_app.api.ingress[0].fqdn}"
      }
    }
    min_replicas = 0
    max_replicas = 2
  }
}