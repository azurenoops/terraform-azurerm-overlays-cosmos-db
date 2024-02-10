# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
#------------------------------------------------------------
data "azurenoopsutils_resource_name" "cosmosdb" {
  for_each      = var.cosmosdb_account
  resource_type = "azurerm_cosmosdb_account"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : module.mod_azregions.location_cli]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, each.key, local.name_suffix, var.use_naming ? "" : "cosmosdb"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
