resource "azurerm_log_analytics_workspace" "logs" {
  name                = local.log_analytics_workspace_name
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}