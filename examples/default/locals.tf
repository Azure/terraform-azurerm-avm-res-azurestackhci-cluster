locals {
  adou_path                    = "OU=${var.resourceGroupName},${var.adouSuffix}"
  cluster_name                 = "cl${var.site_id}"
  custom_location_name         = "customlocation-${var.site_id}"
  keyvault_name                = "kv${var.site_id}"
  witness_storage_account_name = "${lower(var.site_id)}wit"
}
