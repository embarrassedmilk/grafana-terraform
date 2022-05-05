resource "azurerm_storage_share" "grafana" {
  name                 = local.grafana_share_name
  storage_account_name = data.azurerm_storage_account.datalake.name
  quota                = 50
}

resource "azurerm_storage_share_file" "grafana_db" {
  name             = "grafana.db"
  storage_share_id = azurerm_storage_share.grafana.id
  source           = "assets/grafana.db"
}