# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#-------------------------------------------------------------
# CosmosDB (formally DocumentDB) Account - Default (required)
#-------------------------------------------------------------

resource "azurerm_cosmosdb_account" "db" {
  for_each = var.cosmosdb_account
  name     = coalesce(var.custom_cosmosdb_name, data.azurenoopsutils_resource_name.cosmosdb[each.key].result)

  location            = local.location
  resource_group_name = local.resource_group_name

  offer_type = each.value["offer_type"]
  kind       = each.value["kind"]

  analytical_storage_enabled = each.value["analytical_storage_enabled"]
  enable_automatic_failover  = each.value["enable_automatic_failover"]

  key_vault_key_id                   = each.value["key_vault_key_id"]
  enable_multiple_write_locations    = each.value["enable_multiple_write_locations"]
  access_key_metadata_writes_enabled = each.value["access_key_metadata_writes_enabled"]

  mongo_server_version = each.value["kind"] == "MongoDB" ? each.value["mongo_server_version"] : null

  enable_free_tier = each.value["enable_free_tier"]

  dynamic "analytical_storage" {
    for_each = each.value.enable_analytical_storage && each.value.analytical_storage_type != null ? ["enabled"] : []
    content {
      schema_type = each.value.analytical_storage_type
    }
  }

  dynamic "geo_location" {
    for_each = each.value.failover_locations == null ? local.default_failover_locations : each.value.failover_locations
    content {
      #   prefix            = "${format("%s-%s", each.key, random_integer.intg.result)}-${geo_location.value.location}"
      location          = geo_location.value.location
      failover_priority = lookup(geo_location.value, "failover_priority", 0)
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }

  consistency_policy {
    consistency_level       = lookup(each.value.consistency_policy, "consistency_level", "BoundedStaleness")
    max_interval_in_seconds = lookup(each.value.consistency_policy, "consistency_level") == "BoundedStaleness" ? lookup(each.value.consistency_policy, "max_interval_in_seconds", 5) : null
    max_staleness_prefix    = lookup(each.value.consistency_policy, "consistency_level") == "BoundedStaleness" ? lookup(each.value.consistency_policy, "max_staleness_prefix", 100) : null
  }

  dynamic "capabilities" {
    for_each = toset(each.value.capabilities)
    content {
      name = capabilities.key
    }
  }

  ip_range_filter = join(",", each.value.allowed_ip_range_cidrs)

  public_network_access_enabled         = each.value["public_network_access_enabled"]
  is_virtual_network_filter_enabled     = each.value["is_virtual_network_filter_enabled"]
  network_acl_bypass_for_azure_services = each.value["network_acl_bypass_for_azure_services"]
  network_acl_bypass_ids                = each.value["network_acl_bypass_ids"]

  dynamic "virtual_network_rule" {
    for_each = each.value.virtual_network_rules != null ? toset(each.value.virtual_network_rules) : []
    content {
      id                                   = virtual_network_rules.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
    }
  }

  # There is a error in creating backups in azurerm for cosmos_db, so this is commented out
 /*  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      type                = lookup(var.backup, "type", null)
      interval_in_minutes = lookup(var.backup, "interval_in_minutes", null)
      retention_in_hours  = lookup(var.backup, "retention_in_hours", null)
    }
  } */

  dynamic "cors_rule" {
    for_each = each.value.cors_rules != null ? [each.value.cors_rules] : []
    content {
      allowed_headers    = var.cors_rules.allowed_headers
      allowed_methods    = var.cors_rules.allowed_methods
      allowed_origins    = var.cors_rules.allowed_origins
      exposed_headers    = var.cors_rules.exposed_headers
      max_age_in_seconds = var.cors_rules.max_age_in_seconds
    }
  }

  default_identity_type = each.value.default_identity_type == "SystemAssignedIdentity" ? "SystemAssignedIdentity" : each.value.default_identity_type == "UserAssignedIdentity" ? join("=", ["UserAssignedIdentity", one(each.value.existing_principal_ids)]) : "FirstPartyIdentity"

  dynamic "identity" {
    for_each = each.value.managed_identity == true ? [1] : [0]
    content {
      type         = each.value.identity_type
      identity_ids = each.value.identity_type == "UserAssigned" && each.value.default_identity_type == "UserAssignedIdentity" ? each.value.existing_principal_ids : null
    }
  }

  tags = merge(local.default_tags, var.add_tags)
}

#-------------------------------------------------------------
#  CosmosDB azure defender configuration - Default is "false" 
#-------------------------------------------------------------
resource "azurerm_advanced_threat_protection" "db" {
  count              = var.enable_advanced_threat_protection ? 1 : 0
  target_resource_id = element([for n in azurerm_cosmosdb_account.db : n.id], 0)
  enabled            = var.enable_advanced_threat_protection
}
