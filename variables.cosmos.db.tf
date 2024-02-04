# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


##############################
# Cosmos DB Configuration   ##
##############################

variable "offer_type" {
  type        = string
  description = "Specifies the Offer Type to use for this CosmosDB Account - currently this can only be set to Standard."
  default     = "Standard"
}

variable "kind" {
  type        = string
  description = "Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`."
  default     = "GlobalDocumentDB"
}

variable "mongo_server_version" {
  description = "The Server Version of a MongoDB account. See possible values https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account#mongo_server_version"
  type        = string
  default     = "4.2"
}

variable "enable_zone_redundancy" {
  description = "True to enabled zone redundancy on default primary location"
  type        = bool
  default     = true
}

variable "failover_locations" {
  description = "The name of the Azure region to host replicated data and their priority."
  type        = map(map(string))
  default     = null
}

variable "capabilities" {
  type        = list(string)
  description = <<EOD
Configures the capabilities to enable for this Cosmos DB account:
Possible values are
  AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses,
  EnableAggregationPipeline, EnableCassandra, EnableGremlin,EnableMongo, EnableTable, EnableServerless,
  MongoDBv3.4 and mongoEnableDocLevelTTL.
EOD
  default     = []
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "CosmosDB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account."
  default     = []
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this CosmosDB account."
  type        = bool
  default     = true
}

variable "is_virtual_network_filter_enabled" {
  description = "Enables virtual network filtering for this Cosmos DB account"
  type        = bool
  default     = false
}

variable "network_acl_bypass_for_azure_services" {
  description = "If azure services can bypass ACLs."
  type        = bool
  default     = false
}

variable "network_acl_bypass_ids" {
  description = "The list of resource Ids for Network Acl Bypass for this Cosmos DB account."
  type        = list(string)
  default     = null
}

variable "virtual_network_rule" {
  description = "Specifies a virtual_network_rules resource used to define which subnets are allowed to access this CosmosDB account"
  type = list(object({
    subnet_id                            = string,
    ignore_missing_vnet_service_endpoint = bool
  }))
  default = null
}

variable "consistency_policy_level" {
  description = "Consistency policy level. Allowed values are `BoundedStaleness`, `Eventual`, `Session`, `Strong` or `ConsistentPrefix`"
  type        = string
  default     = "BoundedStaleness"
}

variable "consistency_policy_max_interval_in_seconds" {
  description = "When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Accepted range for this value is 5 - 86400 (1 day). Defaults to 5. Required when consistency_level is set to BoundedStaleness."
  type        = number
  default     = 10
}

variable "consistency_policy_max_staleness_prefix" {
  description = "When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Accepted range for this value is 10 – 2147483647. Defaults to 100. Required when consistency_level is set to BoundedStaleness."
  type        = number
  default     = 200
}

variable "backup" {
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
}

variable "enable_analytical_storage" {
  description = "Enable Analytical Storage option for this Cosmos DB account. Defaults to `false`. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "analytical_storage_type" {
  description = "The schema type of the Analytical Storage for this Cosmos DB account. Possible values are `FullFidelity` and `WellDefined`."
  type        = string
  default     = null

  validation {
    condition     = try(contains(["FullFidelity", "WellDefined"], var.analytical_storage_type), true)
    error_message = "The `analytical_storage_type` value must be valid. Possible values are `FullFidelity` and `WellDefined`."
  }
}

variable "identity_type" {
  description = "App configuration identity type. Possible values are `null` `UserAssigned` and `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}

variable "existing_principal_ids" {
  description = "The principal ID of an existing principal ids to use for App Configuration."
  type        = list(string)
  default     = null
}

variable "enable_free_tier" {
  description = "Enable the option to opt-in for the free database account within subscription."
  type        = bool
  default     = false
}

variable "key_vault_key_id" {
  description = "The Key Vault Key ID for the encryption key to use for the account."
  type        = string
  default     = null  
}

variable "default_identity_type" {
  description = "The default identity type to use for the Cosmos DB account. Possible values are `FirstPartyIdentity` `SystemAssignedIdentity` and `UserAssignedIdentity`."
  type        = string
  default     = "FirstPartyIdentity"
  
}