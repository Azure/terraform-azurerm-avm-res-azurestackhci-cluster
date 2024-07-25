data "azuread_service_principal" "hci_rp" {
  count     = var.rpServicePrincipalObjectId == "" ? 1 : 0
  client_id = "1412d89f-b8a8-4111-b4fd-e82905cbd85d"
}

resource "azurerm_role_assignment" "ServicePrincipalRoleAssign" {
  depends_on           = [data.azuread_service_principal.hci_rp]
  for_each             = local.rp_roles
  scope                = var.resourceGroup.id
  role_definition_name = each.value
  principal_id         = var.rpServicePrincipalObjectId == "" ? data.azuread_service_principal.hci_rp[0].object_id : var.rpServicePrincipalObjectId
}
