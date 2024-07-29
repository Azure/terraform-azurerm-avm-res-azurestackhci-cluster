locals {
  adou_path                 = "OU=${var.resourceGroupName},${var.adouSuffix}"
  clusterName               = "cl${var.siteId}"
  customLocationName        = "customlocation-${var.siteId}"
  keyvaultName              = "kv${var.siteId}"
  witnessStorageAccountName = "${lower(var.siteId)}wit"
}
