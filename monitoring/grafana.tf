resource "random_password" "grafana_password" {
  length  = 16
  special = true
}

resource "azurerm_service_plan" "grafana" {
  name                = local.app_service_plan_name
  location            = local.location
  resource_group_name = local.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "grafana" {
  name                = local.app_service_name
  location            = local.location
  resource_group_name = local.resource_group_name
  service_plan_id     = azurerm_service_plan.grafana.id

  site_config {
    application_stack {
      docker_image     = "grafana/grafana"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    "GF_SERVER_ROOT_URL"                          = "https://${local.app_service_name}.azurewebsites.net"
    "GF_SECURITY_ADMIN_PASSWORD"                  = random_password.grafana_password.result
    "GF_INSTALL_PLUGINS"                          = "grafana-clock-panel,grafana-simple-json-datasource"
    "GF_AUTH_GENERIC_OAUTH_NAME"                  = "Azure AD"
    "GF_AUTH_GENERIC_OAUTH_ENABLED"               = "true"
    "GF_AUTH_GENERIC_OAUTH_CLIENT_ID"             = azuread_application.grafana.application_id
    "GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET"         = azuread_application_password.grafana.value
    "GF_AUTH_GENERIC_OAUTH_SCOPES"                = "openid email name"
    "GF_AUTH_GENERIC_OAUTH_AUTH_URL"              = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/authorize"
    "GF_AUTH_GENERIC_OAUTH_TOKEN_URL"             = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/oauth2/token"
    "GF_AUTH_GENERIC_OAUTH_API_URL"               = ""
    "GF_AUTH_GENERIC_OAUTH_TEAM_IDS"              = ""
    "GF_AUTH_GENERIC_OAUTH_ALLOWED_ORGANIZATIONS" = ""
  }

  storage_account {
    access_key   = data.azurerm_storage_account.datalake.primary_access_key
    account_name = data.azurerm_storage_account.datalake.name
    name         = local.app_service_name
    share_name   = azurerm_storage_share.grafana.name
    type         = "AzureFiles"
    mount_path   = "/var/lib/grafana/"
  }

  logs {
    http_logs {
      file_system {
        retention_in_mb   = 35
        retention_in_days = 0
      }
    }
  }

  depends_on = [
    azurerm_storage_share_file.grafana_db
  ]
}

resource "azurerm_key_vault_secret" "grafana_password" {
  name         = "grafana-password"
  value        = random_password.grafana_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}