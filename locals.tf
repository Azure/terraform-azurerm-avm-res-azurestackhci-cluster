locals {
  adapter_properties = {
    jumboPacket             = ""
    networkDirect           = "Disabled"
    networkDirectTechnology = ""
  }
  combined_adapters = setintersection(toset(var.management_adapters), toset(local.storage_adapters))
  converged         = (length(local.combined_adapters) == length(var.management_adapters)) && (length(local.combined_adapters) == length(local.storage_adapters))
  converged_intents = [{
    name                               = var.intent_name,
    trafficType                        = var.traffic_type,
    adapter                            = flatten(var.management_adapters),
    overrideVirtualSwitchConfiguration = false,
    virtualSwitchConfigurationOverrides = {
      enableIov              = "",
      loadBalancingAlgorithm = ""
    },
    overrideQosPolicy        = false,
    qosPolicyOverrides       = var.qos_policy_overrides,
    overrideAdapterProperty  = var.override_adapter_property,
    adapterPropertyOverrides = var.rdma_enabled ? local.rdma_adapter_properties : local.adapter_properties
  }]
  decoded_user_storages = jsondecode(data.azapi_resource_list.user_storages.output).value
  key_vault             = var.create_key_vault ? azurerm_key_vault.deployment_keyvault[0] : data.azurerm_key_vault.key_vault[0]
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
  secrets_location = var.secrets_location == "" ? local.key_vault.vault_uri : var.secrets_location
  seperate_intents = [{
    name                               = var.compute_intent_name,
    trafficType                        = var.compute_traffic_type,
    adapter                            = flatten(var.management_adapters)
    overrideVirtualSwitchConfiguration = false,
    overrideQosPolicy                  = false,
    overrideAdapterProperty            = var.compute_override_adapter_property,
    virtualSwitchConfigurationOverrides = {
      enableIov              = "",
      loadBalancingAlgorithm = ""
    },
    qosPolicyOverrides       = var.compute_qos_policy_overrides,
    adapterPropertyOverrides = var.compute_rdma_enabled ? (var.storage_connectivity_switchless ? local.switchless_adapter_properties : local.rdma_adapter_properties) : local.adapter_properties
    },
    {
      name                               = var.storage_intent_name,
      trafficType                        = var.storage_traffic_type,
      adapter                            = local.storage_adapters,
      overrideVirtualSwitchConfiguration = false,
      overrideQosPolicy                  = false,
      overrideAdapterProperty            = var.storage_override_adapter_property,
      virtualSwitchConfigurationOverrides = {
        enableIov              = "",
        loadBalancingAlgorithm = ""
      },
      qosPolicyOverrides       = var.storage_qos_policy_overrides,
      adapterPropertyOverrides = var.storage_rdma_enabled ? (var.storage_connectivity_switchless ? local.switchless_adapter_properties : local.rdma_adapter_properties) : local.adapter_properties
  }]
  storage_adapters = flatten([for storageNetwork in var.storage_networks : storageNetwork.networkAdapterName])
  switchless_adapter_properties = {
    jumboPacket             = "9014"
    networkDirect           = "Enabled"
    networkDirectTechnology = "iWARP"
  }
  witness_storage_account_resource_group_name = var.witness_storage_account_resource_group_name == "" ? var.resource_group_name : var.witness_storage_account_resource_group_name
}
