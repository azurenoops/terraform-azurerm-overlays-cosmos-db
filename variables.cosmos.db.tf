# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


##############################
# Cosmos DB Configuration   ##
##############################

variable "cosmosdb_account" {
  type = map(object({
    offer_type                            = optional(string, "Standard")
    kind                                  = optional(string, "GlobalDocumentDB")
    enable_free_tier                      = optional(bool, false)
    analytical_storage_enabled            = optional(bool, false)
    enable_automatic_failover             = optional(bool, true)
    public_network_access_enabled         = optional(bool, true)
    is_virtual_network_filter_enabled     = optional(bool, false)
    key_vault_key_id                      = optional(string, null)
    enable_multiple_write_locations       = optional(bool, false)
    access_key_metadata_writes_enabled    = optional(bool, false)
    mongo_server_version                  = optional(string, "4.2")
    network_acl_bypass_for_azure_services = optional(bool, false)
    network_acl_bypass_ids                = optional(list(string), null)
    enable_analytical_storage             = optional(bool, false)
    analytical_storage_type               = optional(string, null)
    managed_identity                      = optional(bool, false)
    identity_type                         = optional(string, "SystemAssigned")
    existing_principal_ids                = optional(list(string), null)
    default_identity_type                 = optional(string, "FirstPartyIdentity")
    consistency_policy = optional(object({
      consistency_level       = string
      max_interval_in_seconds = optional(number, 5)
      max_staleness_prefix    = optional(number, 100)
    })),
    failover_locations = optional(list(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool)
    }))),
    capabilities           = optional(list(string), []),
    allowed_ip_range_cidrs = optional(list(string), []),
    virtual_network_rules = optional(list(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    }))),
    cors_rules = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })),
  }))
  description = "Manages a CosmosDB (formally DocumentDB) Account specifications"
}

# There is a error in creating backups in azurerm for cosmos_db, so this is commented out
/* variable "backup" {
  description = "Backup block with type (Continuous / Periodic), interval_in_minutes and retention_in_hours keys"
  type = object({
    type                = string
    interval_in_minutes = number
    retention_in_hours  = number
  })
  default = {
    type                = "Periodic"
    interval_in_minutes = 3 * 60
    retention_in_hours  = 7 * 24
  }
} */

variable "enable_advanced_threat_protection" {
  description = "Enables Advanced Threat Protection for Azure Cosmos DB. Default is false."
  type        = bool
  default     = false  
}