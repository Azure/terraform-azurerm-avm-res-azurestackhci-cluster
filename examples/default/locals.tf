locals {
  witnessStorageAccountName = "${lower(var.siteId)}wit"
  keyvaultName              = "${var.siteId}-kv"
  adou_path                 = "OU=${var.resourceGroupName},${var.adouSuffix}"
  clusterName               = "${var.siteId}-cl"
  customLocationName        = "${var.siteId}-customlocation"
}
