data "azurerm_arc_machine" "arcservers" {
  for_each = {
    for index, server in var.servers :
    server.name => server.ipv4Address
  }

  name                = each.key
  resource_group_name = var.resource_group_name
}

resource "azapi_resource" "validatedeploymentsetting" {
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
                euLocation          = var.eu_location
                episodicDataUpload  = true
              }
              cluster = {
                name                 = coalesce(var.cluster_name, "") == "" ? azapi_resource.cluster.name : var.cluster_name
                witnessType          = var.witness_type
                witnessPath          = var.witness_path
                cloudAccountName     = var.create_witness_storage_account ? azurerm_storage_account.witness[0].name : var.witness_storage_account_id
                azureServiceEndpoint = var.azure_service_endpoint
              }
              storage = {
                configurationMode = "Express"
              }
              namingPrefix = var.site_id
              domainFqdn   = var.domain_fqdn
              infrastructureNetwork = [{
                useDhcp    = false
                subnetMask = var.subnet_mask
                gateway    = var.default_gateway
                ipPools = [
                  {
                    startingAddress = var.starting_address
                    endingEddress   = var.ending_address
                  }
                ]
                dnsServers = flatten(var.dns_servers)
              }]
              physicalNodes = flatten(var.servers)
              hostNetwork = {
                enableStorageAutoIp           = true
                intents                       = local.converged ? local.converged_intents : local.seperate_intents
                storageNetworks               = flatten(var.storage_networks)
                storageConnectivitySwitchless = false
              }
              adouPath        = var.adou_path
              secretsLocation = coalesce(var.secrets_location, "") == "" ? azurerm_key_vault.deployment_keyvault[0].vault_uri : var.secrets_location
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
