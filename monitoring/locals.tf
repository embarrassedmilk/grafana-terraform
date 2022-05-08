locals {
  location            = "westeurope"
  resource_group_name = "vmatveev-grafana-spike"
  kv_name             = "vmgrafanaspikekv"
  datalake_name       = "vmgrafanaspikedatalake"

  app_service_plan_name = "vm-grafana-spike-asp"
  app_service_name      = "vm-grafana-spike"
  ad_app_display_name   = "vm-grafana-spike"
  grafana_share_name    = "vm-grafana-spike-share"

  microsoft_graph = {
    app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph 
    scopes = [
      "37f7f235-527c-4136-accd-4a02d197296e", # openid
      "64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0", # email
      "14dad69e-099b-42c9-810b-d002981feec1", # profile
    ]
  }
}