data "azurerm_arc_machine" "arcservers" {
  for_each = {
    for index, server in var.servers :
    server.name => server.ipv4Address
  }

  name                = each.key
  resource_group_name = var.resource_group.name
}

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
  rdma_adapter_properties = {
    jumboPacket             = "9014"
    networkDirect           = "Enabled"
    networkDirectTechnology = "RoCEv2"
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


resource "azapi_resource" "validatedeploymentsetting" {
  count = local.converged ? 1 : 0

  type = "Microsoft.AzureStackHCI/clusters/deploymentSettings@2023-08-01-preview"
  body = {
    properties = {
      arcNodeResourceIds = flatten([for server in data.azurerm_arc_machine.arcservers : server.id])
      deploymentMode     = var.is_exported ? "Deploy" : "Validate"
      deploymentConfiguration = {
        version = "10.0.0.0"
        scaleUnits = [
          {
            deploymentData = {
              securitySettings = {
                hvciProtection                = true
                drtmProtection                = true
                driftControlEnforced          = true
                credentialGuardEnforced       = true
                smbSigningEnforced            = true
                smbClusterEncryption          = false
                sideChannelMitigationEnforced = true
                bitlockerBootVolume           = true
                bitlockerDataVolumes          = true
                wdacEnforced                  = true
              }
              observability = {
                streamingDataClient = true
                euLocation          = false
                episodicDataUpload  = true
              }
              cluster = {
                name                 = azapi_resource.cluster.name
                witnessType          = "Cloud"
                witnessPath          = "Cloud"
                cloudAccountName     = azurerm_storage_account.witness.name
                azureServiceEndpoint = "core.windows.net"
              }
              storage = {
                configurationMode = "Express"
              }
              namingPrefix = var.site_id
              domain_fqdn  = var.domain_fqdn
              infrastructureNetwork = [{
                useDhcp     = false
                subnet_mask = var.subnet_mask
                gateway     = var.default_gateway
                ipPools = [
                  {
                    starting_address = var.starting_address
                    ending_address   = var.ending_address
                  }
                ]
                dns_servers = flatten(var.dns_servers)
              }]
              physicalNodes = flatten(var.servers)
              hostNetwork = {
                enableStorageAutoIp             = true
                intents                         = local.converged_intents
                storage_networks                = flatten(var.storage_networks)
                storage_connectivity_switchless = false
              }
              adou_path       = var.adou_path
              secretsLocation = azurerm_key_vault.deployment_keyvault.vault_uri
              optionalServices = {
                customLocation = var.custom_location_name
              }

            }
          }
        ]
      }
    }
  }
  name      = "default"
  parent_id = azapi_resource.cluster.id

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

resource "azapi_resource" "validatedeploymentsetting_seperate" {
  count = local.converged ? 0 : 1

  type = "Microsoft.AzureStackHCI/clusters/deploymentSettings@2023-08-01-preview"
  body = {
    properties = {
      arcNodeResourceIds = flatten([for server in data.azurerm_arc_machine.arcservers : server.id])
      deploymentMode     = "Validate" # Deploy
      deploymentConfiguration = {
        version = "10.0.0.0"
        scaleUnits = [
          {
            deploymentData = {
              securitySettings = {
                hvciProtection                = true
                drtmProtection                = true
                driftControlEnforced          = true
                credentialGuardEnforced       = true
                smbSigningEnforced            = true
                smbClusterEncryption          = false
                sideChannelMitigationEnforced = true
                bitlockerBootVolume           = true
                bitlockerDataVolumes          = true
                wdacEnforced                  = true
              }
              observability = {
                streamingDataClient = true
                euLocation          = false
                episodicDataUpload  = true
              }
              cluster = {
                name                 = azapi_resource.cluster.name
                witnessType          = "Cloud"
                witnessPath          = "Cloud"
                cloudAccountName     = azurerm_storage_account.witness.name
                azureServiceEndpoint = "core.windows.net"
              }
              storage = {
                configurationMode = "Express"
              }
              namingPrefix = var.site_id
              domain_fqdn  = var.domain_fqdn
              infrastructureNetwork = [{
                useDhcp     = false
                subnet_mask = var.subnet_mask
                gateway     = var.default_gateway
                ipPools = [
                  {
                    starting_address = var.starting_address
                    ending_address   = var.ending_address
                  }
                ]
                dns_servers = flatten(var.dns_servers)
              }]
              physicalNodes = flatten(var.servers)
              hostNetwork = {
                enableStorageAutoIp             = true
                intents                         = local.seperate_intents
                storage_networks                = flatten(var.storage_networks)
                storage_connectivity_switchless = false
              }
              adou_path       = var.adou_path
              secretsLocation = azurerm_key_vault.deployment_keyvault.vault_uri
              optionalServices = {
                customLocation = var.custom_location_name
              }
            }
          }
        ]
      }
    }
  }
  name      = "default"
  parent_id = azapi_resource.cluster.id

  depends_on = [
    azurerm_key_vault_secret.default_arb_application,
    azurerm_key_vault_secret.azure_stack_lcm_user_credential,
    azurerm_key_vault_secret.local_admin_credential,
    azurerm_key_vault_secret.witness_storage_key,
    azapi_resource.cluster
  ]

  # ignore the deployment mode change after the first deployment
  lifecycle {
    ignore_changes = [
      body.properties.deploymentMode
    ]
  }
}
