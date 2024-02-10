# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Resource Group Lock configuration - Remove if not needed 
#------------------------------------------------------------
/* resource "azurerm_management_lock" "cosmos_db_level_lock" {
  count = var.enable_resource_locks ? 1 : 0

  name       = "${local.cosmosdb_name}-${var.lock_level}-lock"
  scope      = azurerm_cosmosdb_account.db.id
  lock_level = var.lock_level
  notes      = "'${local.cosmosdb_name}' is locked with '${var.lock_level}' level."
}
 */