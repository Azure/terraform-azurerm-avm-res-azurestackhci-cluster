data "azurerm_arc_machine" "arcservers" {
  for_each = {
    for index, server in var.servers :
    server.name => server.ipv4Address
  }

  name                = each.key
  resource_group_name = local.resource_group_name
}

resource "azapi_resource" "validatedeploymentsetting" {
  name      = "default"
  parent_id = azapi_resource.cluster.id
  type      = "Microsoft.AzureStackHCI/clusters/deploymentSettings@2024-02-15-preview"
  body = {
    properties = local.deployment_setting_properties_omit_null
  }

  depends_on = [
    azurerm_key_vault_secret.default_arb_application,
    azurerm_key_vault_secret.azure_stack_lcm_user_credential,
    azurerm_key_vault_secret.local_admin_credential,
    azurerm_key_vault_secret.witness_storage_key,
    azapi_resource.cluster,
    azurerm_role_assignment.service_principal_role_assign,
  ]

  lifecycle {
    ignore_changes = [
      body.properties.deploymentMode
    ]
  }
}
