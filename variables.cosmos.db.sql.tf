# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


########################################
# Cosmos DB SQL Table Configuration   ##
########################################

variable "create_cosmosdb_table" {
  description = "Manages a Table within a Cosmos DB Account"
  default     = false
}

variable "cosmosdb_table_throughput" {
  description = "The throughput of Table (RU/s). Must be set in increments of `100`. The minimum value is `400`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply."
  default     = null
}

variable "cosmosdb_table_autoscale_settings" {
  type = object({
    max_throughput = string
  })
  description = "The maximum throughput of the Table (RU/s). Must be between `4,000` and `1,000,000`. Must be set in increments of `1,000`. Conflicts with `throughput`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply."
  default     = null
}


##############################
# Cosmos DB Configuration   ##
##############################

variable "create_cosmosdb_sql_database" {
  description = "Manages a SQL Database within a Cosmos DB Account"
  default     = false
}

variable "cosmosdb_sqldb_throughput" {
  description = "The throughput of Table (RU/s). Must be set in increments of `100`. The minimum value is `400`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply."
  default     = 400
}

variable "cosmosdb_sqldb_autoscale_settings" {
  type = object({
    max_throughput = string
  })
  description = "The maximum throughput of the Table (RU/s). Must be between `4,000` and `1,000,000`. Must be set in increments of `1,000`. Conflicts with `throughput`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply."
  default     = null
}

variable "create_cosmosdb_sql_container" {
  description = "Manages a SQL Container within a Cosmos DB Account"
  default     = false
}

variable "partition_key_path" {
  description = "Define a partition key"
  default     = "/definition/id"
}

variable "partition_key_version" {
  description = "Define a partition key version. Possible values are `1` and `2`. This should be set to `2` in order to use large partition keys."
  default     = 1
}

variable "sql_container_throughput" {
  description = "The throughput of SQL container (RU/s). Must be set in increments of `100`. The minimum value is `400`. This must be set upon container creation otherwise it cannot be updated without a manual terraform destroy-apply"
  default     = null
}

variable "sql_container_autoscale_settings" {
  type = object({
    max_throughput = string
  })
  description = "The maximum throughput of the Table (RU/s). Must be between `4,000` and `1,000,000`. Must be set in increments of `1,000`. Conflicts with `throughput`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply."
  default     = null
}

variable "unique_key" {
  type = object({
    paths = list(string)
  })
  description = "A list of paths to use for this unique key"
  default     = null
}

variable "container_indexing_policy" {
  type = object({
    indexing_mode = optional(string)
    included_path = optional(object({
      path = string
    }))
    excluded_path = optional(object({
      path = string
    }))
    composite_index = optional(object({
      index = optional(object({
        path  = string
        order = string
      }))
    }))
    spatial_index = optional(object({
      path = string
    }))
  })
  description = "Specifies how the container's items should be indexed. The default indexing policy for newly created containers indexes every property of every item and enforces range indexes for any string or number"
  default     = null
}

variable "conflict_resolution_policy" {
  type = object({
    mode                          = string
    conflict_resolution_path      = string
    conflict_resolution_procedure = string
  })
  description = "Conflicts and conflict resolution policies are applicable if your Azure Cosmos DB account is configured with multiple write regions"
  default     = null
}

variable "default_ttl" {
  description = "The default time to live of SQL container. If missing, items are not expired automatically. If present and the value is set to `-1`, it is equal to infinity, and items don’t expire by default. If present and the value is set to some number `n` – items will expire `n` seconds after their last modified time."
  default     = null
}

variable "analytical_storage_ttl" {
  description = "The default time to live of Analytical Storage for this SQL container. If present and the value is set to `-1`, it is equal to infinity, and items don’t expire by default. If present and the value is set to some number `n` – items will expire `n2` seconds after their last modified time."
  default     = null
}