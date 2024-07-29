locals {
  decoded_user_storages              = jsondecode(data.azapi_resource_list.user_storages.output).value
  owned_user_storages                = [for storage in local.decoded_user_storages : storage if lower(storage.extendedLocation.name) == lower(data.azapi_resource.customlocation.id)]
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  rp_roles = {
    ACMRM = "Azure Connected Machine Resource Manager",
  }
}
