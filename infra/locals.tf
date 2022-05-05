locals {
  location            = "westeurope"
  resource_group_name = "vmatveev-grafana-spike"
  kv_name             = "vmgrafanaspikekv"

  postgres_name = "vmgrafanaspike"
  database_name = "data"

  log_analytics_workspace_name = "vmatveev-log-analytics"

  datalake_name = "vmgrafanaspikedatalake"

  personal_ip    = jsondecode(data.http.personal_ip.body)
  sql_admin_name = "sqladmin"
}