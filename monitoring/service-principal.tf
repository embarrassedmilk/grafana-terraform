resource "azuread_application" "grafana" {
  display_name = local.ad_app_display_name
  web {
    homepage_url  = "https://${local.app_service_name}.azurewebsites.net"
    redirect_uris = ["https://${local.app_service_name}.azurewebsites.net/login/generic_oauth"]
  }
  identifier_uris = ["api://${local.ad_app_display_name}"]
  owners          = [data.azuread_user.owner.id]

  required_resource_access {
    resource_app_id = local.microsoft_graph.app_id
    dynamic "resource_access" {
      for_each = local.microsoft_graph.scopes
      content {
        id   = resource_access.value
        type = "Scope"
      }
    }
  }
}

resource "azuread_application_password" "grafana" {
  application_object_id = azuread_application.grafana.object_id
}

resource "azurerm_key_vault_secret" "password" {
  name         = "grafana-app-password"
  value        = azuread_application_password.grafana.value
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azuread_service_principal" "grafana" {
  application_id = azuread_application.grafana.application_id
  owners         = [data.azuread_user.owner.id]
}

resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azuread_service_principal.grafana.id
}