variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "siteId" {
  type        = string
  description = "A unique identifier for the site."
}

variable "adouSuffix" {
  type        = string
  default     = "DC=jumpstart,DC=local"
  description = "The suffix of Active Directory OU path."
}

variable "subnetMask" {
  default     = "255.255.255.0"
  type        = string
  description = "The subnet mask for the network."
}

variable "subscriptionId" {
  type        = string
  description = "The subscription ID for resources."
}

variable "resourceGroupName" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "rpServicePrincipalObjectId" {
  default     = ""
  type        = string
  description = "The object ID of the HCI resource provider service principal."
}

variable "deployment_user" {
  type        = string
  default     = "avmdeploy"
  description = "The username for deployment user."
}

variable "deploymentUserPassword" {
  sensitive   = false
  type        = string
  description = "The password for deployment user."
}

variable "localAdminUser" {
  type        = string
  description = "The username for the local administrator account."
}

variable "localAdminPassword" {
  sensitive   = false
  type        = string
  description = "The password for the local administrator account."
}

variable "servicePrincipalId" {
  type        = string
  sensitive   = false
  description = "The service principal ID for ARB."
}

variable "servicePrincipalSecret" {
  type        = string
  sensitive   = false
  description = "The service principal secret."
}
