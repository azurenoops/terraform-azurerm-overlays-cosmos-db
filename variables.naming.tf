# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################
# Generic naming Configuration    ##
####################################
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_naming" {
  description = "Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_resource_group_name" {
  description = "The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "custom_cosmosdb_name" {
  description = "The name of the custom Cosmos DB to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null  
}

variable "custom_cosmosdb_table_name" {
  description = "The name of the custom Cosmos DB Table API. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  default     = null
}

variable "custom_cosmosdb_sql_container_name" {
  description = "The name of the custom Cosmos DB sql container. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  default     = null
}

variable "custom_cosmosdb_sql_database_name" {
  description = "The name of the custom Cosmos DB SQL database. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  default     = null
}
