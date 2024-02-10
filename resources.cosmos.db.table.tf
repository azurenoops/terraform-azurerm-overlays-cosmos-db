# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
#  CosmosDB Table 
#---------------------------------------------------------
resource "azurerm_cosmosdb_table" "main" {
  for_each            = toset(var.create_cosmosdb_table ? var.cosmosdb_account : null)
  name                = coalesce(var.custom_cosmosdb_table_name, format("%s-table", element([for n in azurerm_cosmosdb_account.main : n.name], 0)))
  resource_group_name = local.resource_group_name
  account_name        = element([for n in azurerm_cosmosdb_account.main : n.name], 0)
  throughput          = var.cosmosdb_table_autoscale_settings == null ? var.cosmosdb_table_throughput : null

  dynamic "autoscale_settings" {
    for_each = var.cosmosdb_table_autoscale_settings != null ? [var.cosmosdb_table_autoscale_settings] : []
    content {
      max_throughput = var.cosmosdb_table_throughput == null ? var.cosmosdb_table_autoscale_settings.max_throughput : null
    }
  }
}
