data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

data "azurerm_storage_account" "datalake" {
  name                = local.datalake_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault" "kv" {
  name                = local.kv_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azuread_user" "owner" {
  object_id = data.azurerm_client_config.current.object_id
}