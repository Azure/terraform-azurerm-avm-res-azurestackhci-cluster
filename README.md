<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-azurestackhci-cluster

Module to provision azure stack hci.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.14)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 2.50.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azapi_resource.cluster](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.validatedeploymentsetting](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.validatedeploymentsetting_seperate](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_update_resource.deploymentsetting](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/update_resource) (resource)
- [azurerm_key_vault.deployment_keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_secret.azure_stack_lcm_user_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.default_arb_application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.local_admin_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.witness_storage_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_role_assignment.service_principal_role_assign](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.witness](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_integer.random_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azapi_resource.arc_settings](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource.arcbridge](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource.customlocation](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azapi_resource_list.user_storages](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource_list) (data source)
- [azuread_service_principal.hci_rp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azurerm_arc_machine.arcservers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/arc_machine) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_adou_path"></a> [adou\_path](#input\_adou\_path)

Description: The Active Directory OU path.

Type: `string`

### <a name="input_custom_location_name"></a> [custom\_location\_name](#input\_custom\_location\_name)

Description: The name of the custom location.

Type: `string`

### <a name="input_default_gateway"></a> [default\_gateway](#input\_default\_gateway)

Description: The default gateway for the network.

Type: `string`

### <a name="input_deployment_user"></a> [deployment\_user](#input\_deployment\_user)

Description: The username for the domain administrator account.

Type: `string`

### <a name="input_deployment_user_password"></a> [deployment\_user\_password](#input\_deployment\_user\_password)

Description: The password for the domain administrator account.

Type: `string`

### <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers)

Description: A list of DNS server IP addresses.

Type: `list(string)`

### <a name="input_domain_fqdn"></a> [domain\_fqdn](#input\_domain\_fqdn)

Description: The domain FQDN.

Type: `string`

### <a name="input_ending_address"></a> [ending\_address](#input\_ending\_address)

Description: The ending IP address of the IP address range.

Type: `string`

### <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name)

Description: The name of the key vault.

Type: `string`

### <a name="input_local_admin_password"></a> [local\_admin\_password](#input\_local\_admin\_password)

Description: The password for the local administrator account.

Type: `string`

### <a name="input_local_admin_user"></a> [local\_admin\_user](#input\_local\_admin\_user)

Description: The username for the local administrator account.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_management_adapters"></a> [management\_adapters](#input\_management\_adapters)

Description: A list of management adapters.

Type: `list(string)`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the HCI cluster. Must be the same as the name when preparing AD.

Type: `string`

### <a name="input_rdma_enabled"></a> [rdma\_enabled](#input\_rdma\_enabled)

Description: Indicates whether RDMA is enabled.

Type: `bool`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_servers"></a> [servers](#input\_servers)

Description: A list of servers with their names and IPv4 addresses.

Type:

```hcl
list(object({
    name        = string
    ipv4Address = string
  }))
```

### <a name="input_service_principal_id"></a> [service\_principal\_id](#input\_service\_principal\_id)

Description: The service principal ID for the Azure account.

Type: `string`

### <a name="input_service_principal_secret"></a> [service\_principal\_secret](#input\_service\_principal\_secret)

Description: The service principal secret for the Azure account.

Type: `string`

### <a name="input_site_id"></a> [site\_id](#input\_site\_id)

Description: A unique identifier for the site.

Type: `string`

### <a name="input_starting_address"></a> [starting\_address](#input\_starting\_address)

Description: The starting IP address of the IP address range.

Type: `string`

### <a name="input_storage_connectivity_switchless"></a> [storage\_connectivity\_switchless](#input\_storage\_connectivity\_switchless)

Description: Indicates whether storage connectivity is switchless.

Type: `bool`

### <a name="input_storage_networks"></a> [storage\_networks](#input\_storage\_networks)

Description: A list of storage networks.

Type:

```hcl
list(object({
    name               = string
    networkAdapterName = string
    vlanId             = string
  }))
```

### <a name="input_witness_storage_account_name"></a> [witness\_storage\_account\_name](#input\_witness\_storage\_account\_name)

Description: The name of the witness storage account.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.

Type:

```hcl
object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
```

Default: `null`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_is_exported"></a> [is\_exported](#input\_is\_exported)

Description: Indicate whether the resource is exported

Type: `bool`

Default: `false`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_random_suffix"></a> [random\_suffix](#input\_random\_suffix)

Description: Indicate whether to add random suffix

Type: `bool`

Default: `true`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_rp_service_principal_object_id"></a> [rp\_service\_principal\_object\_id](#input\_rp\_service\_principal\_object\_id)

Description: The object ID of the HCI resource provider service principal.

Type: `string`

Default: `""`

### <a name="input_subnet_mask"></a> [subnet\_mask](#input\_subnet\_mask)

Description: The subnet mask for the network.

Type: `string`

Default: `"255.255.255.0"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_arc_settings"></a> [arc\_settings](#output\_arc\_settings)

Description: Arc settings instance after HCI connected.

### <a name="output_arcbridge"></a> [arcbridge](#output\_arcbridge)

Description: Arc resource bridge instance after HCI connected.

### <a name="output_cluster"></a> [cluster](#output\_cluster)

Description: HCI Cluster instance

### <a name="output_customlocation"></a> [customlocation](#output\_customlocation)

Description: Custom location instance after HCI connected.

### <a name="output_keyvault"></a> [keyvault](#output\_keyvault)

Description: Keyvault instance that stores deployment secrets.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: This is the full output for the resource.

### <a name="output_user_storages"></a> [user\_storages](#output\_user\_storages)

Description: User storage instances after HCI connected.

### <a name="output_v_switch_name"></a> [v\_switch\_name](#output\_v\_switch\_name)

Description: The name of the virtual switch that is used by the network.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->