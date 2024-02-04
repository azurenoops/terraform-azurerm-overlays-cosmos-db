# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------------
# Cosmos DB Account
#---------------------------------------------------------------

resource "azurerm_cosmosdb_account" "db" {
  name = local.cosmosdb_name

  location            = local.location
  resource_group_name = local.resource_group_name

  offer_type           = var.offer_type
  kind                 = var.kind
  mongo_server_version = var.kind == "MongoDB" ? var.mongo_server_version : null
  enable_free_tier     = var.enable_free_tier

  key_vault_key_id = var.key_vault_key_id

  enable_automatic_failover = true

  analytical_storage_enabled = var.enable_analytical_storage

  dynamic "analytical_storage" {
    for_each = var.enable_analytical_storage && var.analytical_storage_type != null ? ["enabled"] : []
    content {
      schema_type = var.analytical_storage_type
    }
  }

  dynamic "geo_location" {
    for_each = var.failover_locations != null ? var.failover_locations : local.default_failover_locations
    content {
      location          = geo_location.value.location
      failover_priority = lookup(geo_location.value, "priority", 0)
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }

  consistency_policy {
    consistency_level       = var.consistency_policy_level
    max_interval_in_seconds = var.consistency_policy_max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy_max_staleness_prefix
  }

  dynamic "capabilities" {
    for_each = toset(var.capabilities)
    content {
      name = capabilities.key
    }
  }

  ip_range_filter = join(",", var.allowed_cidrs)

  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule != null ? toset(var.virtual_network_rule) : []
    content {
      id                                   = virtual_network_rule.value.subnet_id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? ["enabled"] : []
    content {
      type                = lookup(var.backup, "type", null)
      interval_in_minutes = lookup(var.backup, "interval_in_minutes", null)
      retention_in_hours  = lookup(var.backup, "retention_in_hours", null)
    }
  }

  default_identity_type = var.default_identity_type == "SystemAssignedIdentity" ? "SystemAssignedIdentity" : var.default_identity_type == "UserAssignedIdentity" ? join("=", ["UserAssignedIdentity", one(var.existing_principal_ids)]) : "FirstPartyIdentity"

  dynamic "identity" {
    for_each = var.identity_type[*]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" && var.default_identity_type == "UserAssignedIdentity" ? var.existing_principal_ids : null
    }
  }

  tags = merge(local.default_tags, var.add_tags)
}

