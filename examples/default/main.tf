terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

data "azurerm_resource_group" "rg" {
  name = var.resourceGroupName
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location            = data.azurerm_resource_group.rg.location
  name                = "TODO" # TODO update with module.naming.<RESOURCE_TYPE>.name_unique
  resource_group_name = data.azurerm_resource_group.rg.name

  enable_telemetry = var.enable_telemetry # see variables.tf

  resourceGroup   = data.azurerm_resource_group.rg
  siteId          = var.siteId
  domainFqdn      = "jumpstart.local"
  startingAddress = "192.168.1.55"
  endingAddress   = "192.168.1.65"
  subnetMask      = var.subnetMask
  defaultGateway  = "192.168.1.1"
  dnsServers      = ["192.168.1.254"]
  adouPath        = local.adou_path
  servers = [
    {
      name        = "AzSHOST1",
      ipv4Address = "192.168.1.12"
    },
    {
      name        = "AzSHOST2",
      ipv4Address = "192.168.1.13"
    }
  ]
  managementAdapters = ["FABRIC", "FABRIC2"]
  storageNetworks = [
    {
      name               = "Storage1Network",
      networkAdapterName = "StorageA",
      vlanId             = "711"
    },
    {
      name               = "Storage2Network",
      networkAdapterName = "StorageB",
      vlanId             = "712"
    }
  ]
  rdmaEnabled                   = false
  storageConnectivitySwitchless = false
  clusterName                   = local.clusterName
  customLocationName            = local.customLocationName
  witnessStorageAccountName     = local.witnessStorageAccountName
  keyvaultName                  = local.keyvaultName
  randomSuffix                  = true
  subscriptionId                = var.subscriptionId
  deploymentUser                = var.deployment_user
  deploymentUserPassword        = var.deploymentUserPassword
  localAdminUser                = var.localAdminUser
  localAdminPassword            = var.localAdminPassword
  servicePrincipalId            = var.servicePrincipalId
  servicePrincipalSecret        = var.servicePrincipalSecret
  rpServicePrincipalObjectId    = var.rpServicePrincipalObjectId
}
