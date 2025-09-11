resource "azapi_update_resource" "deploymentsetting" {
  count = var.is_exported ? 0 : 1

  name      = "default"
  parent_id = azapi_resource.cluster.id
  type      = "Microsoft.AzureStackHCI/clusters/deploymentSettings@2024-02-15-preview"
  body = {
    properties = {
      deploymentMode = "Deploy"
    }
  }
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  timeouts {
    create = "24h"
    delete = "60m"
  }

  depends_on = [azapi_resource.validatedeploymentsetting]
}
