variable "deployment_user_password" {
  type        = string
  description = "The password for deployment user."
  sensitive   = true
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

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "service_principal_id" {
  type        = string
  description = "The service principal ID for ARB."
}

variable "service_principal_secret" {
  type        = string
  description = "The service principal secret."
}

variable "site_id" {
  type        = string
  description = "A unique identifier for the site."
}

variable "adou_suffix" {
  type        = string
  default     = "DC=jumpstart,DC=local"
  description = "The suffix of Active Directory OU path."
}

variable "deployment_user" {
  type        = string
  default     = "avmdeploy"
  description = "The username for deployment user."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
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
