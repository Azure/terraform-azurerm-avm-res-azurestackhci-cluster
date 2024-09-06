data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "deployment_keyvault" {
  location                        = data.azurerm_resource_group.rg.location
  name                            = var.random_suffix ? "${var.keyvault_name}-${random_integer.random_suffix.result}" : var.keyvault_name
  resource_group_name             = var.resource_group_name
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization       = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = true
  # arm template has enableSoftDelete": false, but terraform can't disable it after version 2.42.
  soft_delete_retention_days = var.keyvault_soft_delete_retention_days
  tags                       = var.keyvault_tags
}

resource "azurerm_key_vault_secret" "azure_stack_lcm_user_credential" {
  key_vault_id    = azurerm_key_vault.deployment_keyvault.id
  name            = "AzureStackLCMUserCredential"
  value           = base64encode("${var.deployment_user}:${var.deployment_user_password}")
  content_type    = flatten([var.azure_stack_lcm_user_credential_content_type])[0]
  expiration_date = var.azure_stack_lcm_user_credential_expiration_date
  tags            = var.azure_stack_lcm_user_credential_tags

  depends_on = [azurerm_key_vault.deployment_keyvault]
}

resource "azurerm_key_vault_secret" "local_admin_credential" {
  key_vault_id    = azurerm_key_vault.deployment_keyvault.id
  name            = "LocalAdminCredential"
  value           = base64encode("${var.local_admin_user}:${var.local_admin_password}")
  content_type    = flatten([var.local_admin_credential_content_type])[0]
  expiration_date = var.local_admin_credential_expiration_date
  tags            = var.local_admin_credential_tags

  depends_on = [azurerm_key_vault.deployment_keyvault]
}

resource "azurerm_key_vault_secret" "default_arb_application" {
  key_vault_id    = azurerm_key_vault.deployment_keyvault.id
  name            = "DefaultARBApplication"
  value           = base64encode("${var.service_principal_id}:${var.service_principal_secret}")
  content_type    = flatten([var.default_arb_application_content_type])[0]
  expiration_date = var.default_arb_application_expiration_date
  tags            = var.default_arb_application_tags

  depends_on = [azurerm_key_vault.deployment_keyvault]
}

resource "azurerm_key_vault_secret" "witness_storage_key" {
  key_vault_id    = azurerm_key_vault.deployment_keyvault.id
  name            = "WitnessStorageKey"
  value           = base64encode(azurerm_storage_account.witness.primary_access_key)
  content_type    = flatten([var.witness_storage_key_content_type])[0]
  expiration_date = var.witness_storage_key_expiration_date
  tags            = var.witness_storage_key_tags

  depends_on = [azurerm_key_vault.deployment_keyvault]
}
