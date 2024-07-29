<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.74)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_deploymentUserPassword"></a> [deploymentUserPassword](#input\_deploymentUserPassword)

Description: The password for deployment user.

Type: `string`

### <a name="input_localAdminPassword"></a> [localAdminPassword](#input\_localAdminPassword)

Description: The password for the local administrator account.

Type: `string`

### <a name="input_localAdminUser"></a> [localAdminUser](#input\_localAdminUser)

Description: The username for the local administrator account.

Type: `string`

### <a name="input_resourceGroupName"></a> [resourceGroupName](#input\_resourceGroupName)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_servicePrincipalId"></a> [servicePrincipalId](#input\_servicePrincipalId)

Description: The service principal ID for ARB.

Type: `string`

### <a name="input_servicePrincipalSecret"></a> [servicePrincipalSecret](#input\_servicePrincipalSecret)

Description: The service principal secret.

Type: `string`

### <a name="input_siteId"></a> [siteId](#input\_siteId)

Description: A unique identifier for the site.

Type: `string`

### <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId)

Description: The subscription ID for resources.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_adouSuffix"></a> [adouSuffix](#input\_adouSuffix)

Description: The suffix of Active Directory OU path.

Type: `string`

Default: `"DC=jumpstart,DC=local"`

### <a name="input_deployment_user"></a> [deployment\_user](#input\_deployment\_user)

Description: The username for deployment user.

Type: `string`

Default: `"avmdeploy"`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_rpServicePrincipalObjectId"></a> [rpServicePrincipalObjectId](#input\_rpServicePrincipalObjectId)

Description: The object ID of the HCI resource provider service principal.

Type: `string`

Default: `""`

### <a name="input_subnetMask"></a> [subnetMask](#input\_subnetMask)

Description: The subnet mask for the network.

Type: `string`

Default: `"255.255.255.0"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: ~> 0.3

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/regions/azurerm

Version: ~> 0.3

### <a name="module_test"></a> [test](#module\_test)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->