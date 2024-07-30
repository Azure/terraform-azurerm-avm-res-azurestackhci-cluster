resource "azurerm_storage_account" "witness" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = data.azurerm_resource_group.rg.location
  name                     = var.random_suffix ? "${var.witness_storage_account_name}${random_integer.random_suffix.result}" : var.witness_storage_account_name
  resource_group_name      = var.resource_group_name
  tags                     = {}
}
