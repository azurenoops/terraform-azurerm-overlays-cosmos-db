# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "cosmosdb_id" {
  value = module.mod_cosmos_db.cosmosdb_id
}

output "cosmosdb_name" {
  value = module.mod_cosmos_db.cosmosdb_name
}