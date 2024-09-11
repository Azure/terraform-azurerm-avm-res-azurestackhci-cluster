locals {
  adapter_properties = {
    jumboPacket             = ""
    networkDirect           = "Disabled"
    networkDirectTechnology = ""
  }
  combined_adapters = setintersection(toset(var.management_adapters), toset(local.storage_adapters))
  converged         = (length(local.combined_adapters) == length(var.management_adapters)) && (length(local.combined_adapters) == length(local.storage_adapters))
  converged_intents = [{
    name                               = var.converged_intents_name,
    trafficType                        = var.converged_traffic_type,
    adapter                            = flatten(var.management_adapters),
    overrideVirtualSwitchConfiguration = false,
    virtualSwitchConfigurationOverrides = {
      enableIov              = "",
      loadBalancingAlgorithm = ""
    },
    overrideQosPolicy        = false,
    qosPolicyOverrides       = var.converged_qos_policy_overrides,
    overrideAdapterProperty  = var.converged_override_adapter_property,
    adapterPropertyOverrides = var.converged_rdma_enabled ? local.rdma_adapter_properties : local.adapter_properties
  }]
  decoded_user_storages = jsondecode(data.azapi_resource_list.user_storages.output).value
  key_vault             = var.create_key_vault ? azurerm_key_vault.deployment_keyvault[0].id : data.azurerm_key_vault.key_vault[0].id
  key_vault_id          = var.create_key_vault ? azurerm_key_vault.deployment_keyvault[0].id : data.azurerm_key_vault.key_vault[0].id
  owned_user_storages   = [for storage in local.decoded_user_storages : storage if lower(storage.extendedLocation.name) == lower(data.azapi_resource.customlocation.id)]
  rdma_adapter_properties = {
    jumboPacket             = "9014"
    networkDirect           = "Enabled"
    networkDirectTechnology = "RoCEv2"
  }
  role_assignments = flatten([
    for server_key, arcserver in data.azurerm_arc_machine.arcservers : [
      for role_key, role_name in local.roles : {
        server_name  = server_key
        principal_id = arcserver.identity[0].principal_id
        role_name    = role_name
        role_key     = role_key
      }
    ]
  ])
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  roles = {
    KVSU = "Key Vault Secrets User",
  }
  rp_roles = {
    ACMRM = "Azure Connected Machine Resource Manager",
  }
  seperate_intents = [{
    name                               = var.seperate_intents_compute_name,
    trafficType                        = var.seperate_traffic_type,
    adapter                            = flatten(var.management_adapters)
    overrideVirtualSwitchConfiguration = false,
    overrideQosPolicy                  = false,
    overrideAdapterProperty            = var.seperate_compute_override_adapter_property,
    virtualSwitchConfigurationOverrides = {
      enableIov              = "",
      loadBalancingAlgorithm = ""
    },
    qosPolicyOverrides       = var.seperate_compute_qos_policy_overrides,
    adapterPropertyOverrides = var.seperate_compute_rdma_enabled ? (var.storage_connectivity_switchless ? local.switchless_adapter_properties : local.rdma_adapter_properties) : local.adapter_properties
    },
    {
      name = var.seperate_intents_storage_name,
      trafficType = [
        "Storage"
      ],
      adapter                            = local.storage_adapters,
      overrideVirtualSwitchConfiguration = false,
      overrideQosPolicy                  = false,
      overrideAdapterProperty            = var.seperate_storage_override_adapter_property,
      virtualSwitchConfigurationOverrides = {
        enableIov              = "",
        loadBalancingAlgorithm = ""
      },
      qosPolicyOverrides       = var.seperate_storage_qos_policy_overrides,
      adapterPropertyOverrides = var.seperate_storage_rdma_enabled ? (var.storage_connectivity_switchless ? local.switchless_adapter_properties : local.rdma_adapter_properties) : local.adapter_properties
  }]
  # Get the resource group name and storage account name from the witness storage account id
  storage_account_id_is_valid = var.create_witness_storage_account || length(var.witness_storage_account_id) > 0
  storage_account_id_parts = can(regex(
    "^/subscriptions/([^/]+)/resourceGroups/([^/]+)/providers/Microsoft.Storage/storageAccounts/([^/]+)$",
    var.witness_storage_account_id
    )) ? regex(
    "^/subscriptions/([^/]+)/resourceGroups/([^/]+)/providers/Microsoft.Storage/storageAccounts/([^/]+)$",
    var.witness_storage_account_id
  ) : ["", "", ""]
  storage_adapters = flatten([for storageNetwork in var.storage_networks : storageNetwork.networkAdapterName])
  switchless_adapter_properties = {
    jumboPacket             = "9014"
    networkDirect           = "Enabled"
    networkDirectTechnology = "iWARP"
  }
  witness_storage_account_name                 = local.storage_account_id_is_valid ? local.storage_account_id_parts[2] : ""
  witness_storeage_account_resource_group_name = local.storage_account_id_is_valid ? local.storage_account_id_parts[1] : ""
}
