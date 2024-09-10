variable "adou_path" {
  type        = string
  description = "The Active Directory OU path."
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
  sensitive   = true
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS server IP addresses."
  nullable    = false
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
  sensitive   = true
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
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the HCI cluster. Must be the same as the name when preparing AD."

  validation {
    condition     = length(var.name) < 16 && length(var.name) > 0
    error_message = "value of name should be less than 16 characters and greater than 0 characters"
  }
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

variable "witness_storage_account_name" {
  type        = string
  description = "The name of the witness storage account."
}

variable "account_replication_type" {
  type        = string
  default     = "ZRS"
  description = "The replication type for the storage account."
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  default     = false
  description = "Indicates whether nested items can be public."
}

variable "azure_service_endpoint" {
  type        = string
  default     = "core.windows.net"
  description = "The Azure service endpoint."
}

variable "azure_stack_lcm_user_credential_content_type" {
  type        = string
  default     = null
  description = "(Optional) Content type of the azure stack lcm user credential."
}

variable "azure_stack_lcm_user_credential_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the azure stack lcm user credential."
}

variable "cluster_name" {
  type        = string
  default     = null
  description = "The name of the HCI cluster."
}

variable "cluster_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the cluster."
}

variable "converged_intents_name" {
  type        = string
  default     = "ManagementComputeStorage"
  description = "The name of converged intents."
}

variable "converged_override_adapter_property" {
  type        = bool
  default     = true
  description = "Indicates whether to override adapter property."
}

variable "converged_qos_policy_overrides" {
  type = object({
    priorityValue8021Action_SMB     = string
    priorityValue8021Action_Cluster = string
    bandwidthPercentage_SMB         = string
  })
  default = {
    priorityValue8021Action_SMB     = ""
    priorityValue8021Action_Cluster = ""
    bandwidthPercentage_SMB         = ""
  }
  description = "QoS policy overrides for network settings with required properties."
}

variable "converged_rdma_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether RDMA is enabled."
}

variable "create_key_vault" {
  type        = bool
  default     = true
  description = "Set to true to create the key vault, or false to skip it"
}

variable "create_witness_storage_account" {
  type        = bool
  default     = true
  description = "Set to true to create the witness storage account, or false to skip it"
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether cross-tenant replication is enabled."
}

variable "default_arb_application_content_type" {
  type        = string
  default     = null
  description = "(Optional) Content type of the default arb application."
}

variable "default_arb_application_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the default arb application."
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

variable "eu_location" {
  type        = bool
  default     = false
  description = "Indicates whether the location is in EU."
}

variable "is_exported" {
  type        = bool
  default     = false
  description = "Indicate whether the resource is exported"
}

variable "key_vault_location" {
  type        = string
  default     = ""
  description = "The location of the key vault."
}

variable "key_vault_name" {
  type        = string
  default     = ""
  description = "The name of the key vault."

  validation {
    condition     = var.create_key_vault || var.key_vault_name != ""
    error_message = "If 'create_key_vault' is false, 'key_vault_name' must be provided."
  }
}

variable "keyvault_purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether purge protection is enabled."
}

variable "keyvault_soft_delete_retention_days" {
  type        = number
  default     = 30
  description = "The number of days that items should be retained for soft delete."
}

variable "keyvault_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the keyvault."
}

variable "local_admin_credential_content_type" {
  type        = string
  default     = null
  description = "(Optional) Content type of the local admin credential."
}

variable "local_admin_credential_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the local admin credential."
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

variable "min_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "The minimum TLS version."
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

variable "secrets_location" {
  type        = string
  default     = null
  description = "Secrets location for the deployment."
}

variable "seperate_compute_override_adapter_property" {
  type        = bool
  default     = true
  description = "Indicates whether to override adapter property for compute."
}

variable "seperate_compute_qos_policy_overrides" {
  type = object({
    priorityValue8021Action_SMB     = string
    priorityValue8021Action_Cluster = string
    bandwidthPercentage_SMB         = string
  })
  default = {
    priorityValue8021Action_SMB     = ""
    priorityValue8021Action_Cluster = ""
    bandwidthPercentage_SMB         = ""
  }
  description = "QoS policy overrides for network settings with required properties for compute."
}

variable "seperate_compute_rdma_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether RDMA is enabled for compute."
}

variable "seperate_intents_compute_name" {
  type        = string
  default     = "ManagementCompute"
  description = "The name of compute intents."
}

variable "seperate_intents_storage_name" {
  type        = string
  default     = "Storage"
  description = "The name of storage intents."
}

variable "seperate_storage_override_adapter_property" {
  type        = bool
  default     = true
  description = "Indicates whether to override adapter property for storagte."
}

variable "seperate_storage_qos_policy_overrides" {
  type = object({
    priorityValue8021Action_SMB     = string
    priorityValue8021Action_Cluster = string
    bandwidthPercentage_SMB         = string
  })
  default = {
    priorityValue8021Action_SMB     = ""
    priorityValue8021Action_Cluster = ""
    bandwidthPercentage_SMB         = ""
  }
  description = "QoS policy overrides for network settings with required properties for storage."
}

variable "seperate_storage_rdma_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether RDMA is enabled for storage."
}

variable "storage_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the storage."
}

variable "subnet_mask" {
  type        = string
  default     = "255.255.255.0"
  description = "The subnet mask for the network."
}

variable "traffic_type" {
  type = list(string)
  default = [
    "Management",
    "Compute",
    "Storage"
  ]
  description = "Traffic type of converged intents."
}

variable "witness_path" {
  type        = string
  default     = "Cloud"
  description = "The path to the witness."
}

variable "witness_storage_account_id" {
  type        = string
  default     = ""
  description = "The ID of the storage account."

  validation {
    condition     = var.create_witness_storage_account || var.witness_storage_account_id != ""
    error_message = "If 'create_witness_storage_account' is false, 'witness_storage_account_id' must be provided."
  }
}

variable "witness_storage_key_content_type" {
  type        = string
  default     = null
  description = "(Optional) Content type of the witness storage key."
}

variable "witness_storage_key_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the witness storage key."
}

variable "witness_type" {
  type        = string
  default     = "Cloud"
  description = "The type of the witness."
}
