variable "adou_path" {
  type        = string
  description = "The Active Directory OU path."
}

variable "cluster_name" {
  type        = string
  description = "The name of the HCI cluster. Must be the same as the name when preparing AD."

  validation {
    condition     = length(var.cluster_name) < 16 && length(var.cluster_name) > 0
    error_message = "value of cluster_name should be less than 16 characters and greater than 0 characters"
  }
}

variable "custom_location_name" {
  type        = string
  description = "The name of the custom location."
}

variable "default_gateway" {
  type        = string
  description = "The default gateway for the network."
}

variable "deployment_user" {
  type        = string
  description = "The username for the domain administrator account."
}

variable "deployment_user_password" {
  type        = string
  description = "The password for the domain administrator account."
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS server IP addresses."
}

# deploymentSettings related variables  
variable "domain_fqdn" {
  type        = string
  description = "The domain FQDN."
}

variable "ending_address" {
  type        = string
  description = "The ending IP address of the IP address range."
}

variable "keyvault_name" {
  type        = string
  description = "The name of the key vault."
}

variable "local_admin_password" {
  type        = string
  description = "The password for the local administrator account."
}

variable "local_admin_user" {
  type        = string
  description = "The username for the local administrator account."
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "management_adapters" {
  type        = list(string)
  description = "A list of management adapters."
}

variable "name" {
  type        = string
  description = "The name of the this resource."
}

variable "rdma_enabled" {
  type        = bool
  description = "Indicates whether RDMA is enabled."
}

variable "resource_group" {
  description = "The resource group where the resources will be deployed."
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "servers" {
  type = list(object({
    name        = string
    ipv4Address = string
  }))
  description = "A list of servers with their names and IPv4 addresses."
}

variable "service_principal_id" {
  type        = string
  description = "The service principal ID for the Azure account."
}

variable "service_principal_secret" {
  type        = string
  description = "The service principal secret for the Azure account."
}

variable "site_id" {
  type        = string
  description = "A unique identifier for the site."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,8}$", var.site_id))
    error_message = "value of site_id should be less than 9 characters and greater than 0 characters and only contain alphanumeric characters and hyphens, this is the requirement of name prefix in hci deploymentsetting"
  }
}

variable "starting_address" {
  type        = string
  description = "The starting IP address of the IP address range."
}

variable "storage_connectivity_switchless" {
  type        = bool
  description = "Indicates whether storage connectivity is switchless."
}

variable "storage_networks" {
  type = list(object({
    name               = string
    networkAdapterName = string
    vlanId             = string
  }))
  description = "A list of storage networks."
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID for the Azure account."
}

variable "witness_storage_account_name" {
  type        = string
  description = "The name of the witness storage account."
}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.
DESCRIPTION  
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "is_exported" {
  type        = bool
  default     = false
  description = "Indicate whether the resource is exported"
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

variable "random_suffix" {
  type        = bool
  default     = true
  description = "Indicate whether to add random suffix"
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "rp_service_principal_object_id" {
  type        = string
  default     = ""
  description = "The object ID of the HCI resource provider service principal."
}

variable "subnet_mask" {
  type        = string
  default     = "255.255.255.0"
  description = "The subnet mask for the network."
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
