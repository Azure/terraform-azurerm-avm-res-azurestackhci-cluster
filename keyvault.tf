data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "DeploymentKeyVault" {
  location                        = var.resourceGroup.location
  name                            = var.randomSuffix ? "${var.keyvaultName}-${random_integer.random_suffix.result}" : var.keyvaultName
  resource_group_name             = var.resourceGroup.name
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization       = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = true
  // arm template has enableSoftDelete": false, but terraform can't disable it after version 2.42.
  soft_delete_retention_days = 30
  tags                       = {}
}

resource "azurerm_key_vault_secret" "AzureStackLCMUserCredential" {
  key_vault_id = azurerm_key_vault.DeploymentKeyVault.id
  name         = "AzureStackLCMUserCredential"
  value        = base64encode("${var.deploymentUser}:${var.deploymentUserPassword}")
  content_type = "Secret"
  tags         = {}

  depends_on = [azurerm_key_vault.DeploymentKeyVault]
}

resource "azurerm_key_vault_secret" "LocalAdminCredential" {
  key_vault_id = azurerm_key_vault.DeploymentKeyVault.id
  name         = "LocalAdminCredential"
  value        = base64encode("${var.localAdminUser}:${var.localAdminPassword}")
  content_type = "Secret"
  tags         = {}

  depends_on = [azurerm_key_vault.DeploymentKeyVault]
}

resource "azurerm_key_vault_secret" "DefaultARBApplication" {
  key_vault_id = azurerm_key_vault.DeploymentKeyVault.id
  name         = "DefaultARBApplication"
  value        = base64encode("${var.servicePrincipalId}:${var.servicePrincipalSecret}")
  content_type = "Secret"
  tags         = {}

  depends_on = [azurerm_key_vault.DeploymentKeyVault]
}

resource "azurerm_key_vault_secret" "WitnessStorageKey" {
  key_vault_id = azurerm_key_vault.DeploymentKeyVault.id
  name         = "WitnessStorageKey"
  value        = base64encode(azurerm_storage_account.witness.primary_access_key)
  content_type = "Secret"
  tags         = {}

  depends_on = [azurerm_key_vault.DeploymentKeyVault]
}
