data "azurerm_arc_machine" "arcservers" {
  for_each = {
    for index, server in var.servers :
    server.name => server.ipv4Address
  }

  name                = each.key
  resource_group_name = var.resource_group_name
}

resource "azapi_resource" "validatedeploymentsetting" {
  type = "Microsoft.AzureStackHCI/clusters/deploymentSettings@2024-04-01"
  body = {
    properties = {
      arcNodeResourceIds = flatten([for server in data.azurerm_arc_machine.arcservers : server.id])
      deploymentMode     = var.is_exported ? "Deploy" : "Validate"
      operationType      = var.operation_type
      deploymentConfiguration = {
        version = "10.0.0.0"
        scaleUnits = [
          {
            deploymentData = {
              securitySettings = {
                hvciProtection                = var.hvci_protection
                drtmProtection                = var.drtm_protection
                driftControlEnforced          = var.drift_control_enforced
                credentialGuardEnforced       = var.credential_guard_enforced
                smbSigningEnforced            = var.smb_signing_enforced
                smbClusterEncryption          = var.smb_cluster_encryption
                sideChannelMitigationEnforced = var.side_channel_mitigation_enforced
                bitlockerBootVolume           = var.bitlocker_boot_volume
                bitlockerDataVolumes          = var.bitlocker_data_volumes
                wdacEnforced                  = var.wdac_enforced
              }
              observability = {
                streamingDataClient = true
                euLocation          = var.eu_location
                episodicDataUpload  = true
              }
              cluster = {
                name                 = var.cluster_name == "" ? azapi_resource.cluster.name : var.cluster_name
                witnessType          = var.witness_type
                witnessPath          = var.witness_path
                cloudAccountName     = var.create_witness_storage_account ? azurerm_storage_account.witness[0].name : var.witness_storage_account_name
                azureServiceEndpoint = var.azure_service_endpoint
              }
              storage = {
                configurationMode = var.configuration_mode
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
                    endingAddress   = var.ending_address
                  }
                ]
                dnsServers = flatten(var.dns_servers)
              }]
              physicalNodes = flatten(var.servers)
              hostNetwork = {
                enableStorageAutoIp           = true
                intents                       = local.converged ? local.converged_intents : local.seperate_intents
                storageNetworks               = local.storage_networks
                storageConnectivitySwitchless = false
              }
              adouPath        = var.adou_path
              secretsLocation = var.use_legacy_key_vault_model ? local.secrets_location : null
              secrets = var.use_legacy_key_vault_model ? null : [
                {
                  secretName     = "${var.name}-AzureStackLCMUserCredential"
                  eceSecretName  = "AzureStackLCMUserCredential"
                  secretLocation = "${local.secrets_location}secrets/${var.name}-AzureStackLCMUserCredential"
                },
                {
                  secretName     = "${var.name}-LocalAdminCredential"
                  eceSecretName  = "LocalAdminCredential"
                  secretLocation = "${local.secrets_location}secrets/${var.name}-LocalAdminCredential"
                },
                {
                  secretName     = "${var.name}-DefaultARBApplication"
                  eceSecretName  = "DefaultARBApplication"
                  secretLocation = "${local.secrets_location}secrets/${var.name}-DefaultARBApplication"
                },
                {
                  secretName     = "${var.name}-WitnessStorageKey"
                  eceSecretName  = "WitnessStorageKey"
                  secretLocation = "${local.secrets_location}secrets/${var.name}-WitnessStorageKey"
                }
              ]
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
