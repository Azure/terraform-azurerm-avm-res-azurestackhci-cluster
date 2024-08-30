data "azuread_service_principal" "hci_rp" {
  count = var.rp_service_principal_object_id == "" ? 1 : 0

  client_id = "1412d89f-b8a8-4111-b4fd-e82905cbd85d"
}

resource "azurerm_role_assignment" "service_principal_role_assign" {
  for_each = local.rp_roles

  principal_id         = var.rp_service_principal_object_id == "" ? data.azuread_service_principal.hci_rp[0].object_id : var.rp_service_principal_object_id
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = each.value

  depends_on = [data.azuread_service_principal.hci_rp]
}
