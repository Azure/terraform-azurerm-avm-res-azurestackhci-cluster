locals {
  adapter_properties = {
    jumboPacket             = ""
    networkDirect           = "Disabled"
    networkDirectTechnology = ""
  }
  combined_adapters = setintersection(toset(var.management_adapters), toset(local.storage_adapters))
  converged         = (length(local.combined_adapters) == length(var.management_adapters)) && (length(local.combined_adapters) == length(local.storage_adapters))
  converged_intents = [{
    name = "ManagementComputeStorage",
    trafficType = [
      "Management",
      "Compute",
      "Storage"
    ],
    adapter                            = flatten(var.management_adapters),
    overrideVirtualSwitchConfiguration = false,
    virtualSwitchConfigurationOverrides = {
      enableIov              = "",
      loadBalancingAlgorithm = ""
    },
    overrideQosPolicy = false,
    qosPolicyOverrides = {
      priorityValue8021Action_SMB     = "",
      priorityValue8021Action_Cluster = "",
      bandwidthPercentage_SMB         = ""
    },
    overrideAdapterProperty  = true,
    adapterPropertyOverrides = var.rdma_enabled ? local.rdma_adapter_properties : local.adapter_properties
  }]
  decoded_user_storages = jsondecode(data.azapi_resource_list.user_storages.output).value
  owned_user_storages   = [for storage in local.decoded_user_storages : storage if lower(storage.extendedLocation.name) == lower(data.azapi_resource.customlocation.id)]
  rdma_adapter_properties = {
    jumboPacket             = "9014"
    networkDirect           = "Enabled"
    networkDirectTechnology = "RoCEv2"
  }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  rp_roles = {
    ACMRM = "Azure Connected Machine Resource Manager",
  }
  seperate_intents = [{
    name = "ManagementCompute",
    trafficType = [
      "Management",
      "Compute"
    ],
    adapter                            = flatten(var.management_adapters)
    overrideVirtualSwitchConfiguration = false,
    overrideQosPolicy                  = false,
    overrideAdapterProperty            = true,
    virtualSwitchConfigurationOverrides = {
      enableIov              = "",
      loadBalancingAlgorithm = ""
    },
    qosPolicyOverrides = {
      priorityValue8021Action_Cluster = "",
      priorityValue8021Action_SMB     = "",
      bandwidthPercentage_SMB         = ""
    },
    adapterPropertyOverrides = {
      jumboPacket             = "",
      networkDirect           = "Disabled",
      networkDirectTechnology = ""
    }
    },
    {
      name = "Storage",
      trafficType = [
        "Storage"
      ],
      adapter                            = local.storage_adapters,
      overrideVirtualSwitchConfiguration = false,
      overrideQosPolicy                  = false,
      overrideAdapterProperty            = true,
      virtualSwitchConfigurationOverrides = {
        enableIov              = "",
        loadBalancingAlgorithm = ""
      },
      qosPolicyOverrides = {
        priorityValue8021Action_Cluster = "",
        priorityValue8021Action_SMB     = "",
        bandwidthPercentage_SMB         = ""
      },
      adapterPropertyOverrides = var.rdma_enabled ? (var.storage_connectivity_switchless ? local.switchless_adapter_properties : local.rdma_adapter_properties) : local.adapter_properties
  }]
  storage_adapters = flatten([for storageNetwork in var.storage_networks : storageNetwork.networkAdapterName])
  switchless_adapter_properties = {
    jumboPacket             = "9014"
    networkDirect           = "Enabled"
    networkDirectTechnology = "iWARP"
  }
}
