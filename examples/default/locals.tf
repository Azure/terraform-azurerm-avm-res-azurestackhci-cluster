locals {
  witnessStorageAccountName = "${lower(var.siteId)}wit"
  keyvaultName              = "kv${var.siteId}"
  adou_path                 = "OU=${var.resourceGroupName},${var.adouSuffix}"
  clusterName               = "cl${var.siteId}"
  customLocationName        = "customlocation-${var.siteId}"
}
