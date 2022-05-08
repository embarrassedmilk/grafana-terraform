resource "random_password" "password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "password" {
  name         = "db-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_postgresql_server" "source" {
  name                          = local.postgres_name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  public_network_access_enabled = true

  administrator_login              = local.sql_admin_name
  administrator_login_password     = azurerm_key_vault_secret.password.value
  backup_retention_days            = 7
  sku_name                         = "B_Gen5_1"
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
  storage_mb                       = 5120
  version                          = "11"
}

resource "azurerm_postgresql_database" "db" {
  name                = local.database_name
  resource_group_name = azurerm_resource_group.rg.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  server_name         = azurerm_postgresql_server.source.name
}

resource "azurerm_postgresql_firewall_rule" "home" {
  name                = "home"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.source.name
  start_ip_address    = local.personal_ip.ip
  end_ip_address      = local.personal_ip.ip
}