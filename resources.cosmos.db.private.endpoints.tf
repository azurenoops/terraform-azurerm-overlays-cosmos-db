# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Remove this file is you are not using the private endpoints. 
# Remove the comments to enable the private endpoints.

#---------------------------------------------------------
# Private Link for <<name of resource>> - Default is "false" 
#---------------------------------------------------------
data "azurerm_virtual_network" "vnet" {
  count               = var.enable_private_endpoint && var.existing_private_virtual_network_name != null ? 1 : 0
  name                = var.existing_private_virtual_network_name
  resource_group_name = local.resource_group_name
}

data "azurerm_subnet" "snet" {
  count                = var.enable_private_endpoint && var.existing_private_subnet_name != null ? 1 : 0
  name                 = var.existing_private_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.0.name
  resource_group_name  = local.resource_group_name
}

resource "azurerm_private_endpoint" "pep" {
  count               = var.enable_private_endpoint && var.existing_private_subnet_name != null ? 1 : 0
  name                = format("%s-private-endpoint", element([for n in azurerm_cosmosdb_account.db : n.name], 0))
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = data.azurerm_subnet.snet.0.id
  tags                = merge({ "Name" = format("%s-private-endpoint", element([for n in azurerm_cosmosdb_account.db : n.name], 0)) }, var.add_tags, )

  private_service_connection {
    name                           = "cosmos-db-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = element([for n in azurerm_cosmosdb_account.db : n.id], 0)
    subresource_names              = var.resource_types
  }
}

#------------------------------------------------------------------
# DNS zone & records for KV Private endpoints - Default is "false" 
#------------------------------------------------------------------
data "azurerm_private_endpoint_connection" "pip" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_private_endpoint.pep.0.name
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_cosmosdb_account.db]
}

resource "azurerm_private_dns_zone" "dns_zone" {
  count               = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = var.environment == "public" ? "privatelink.documents.azure.com" : "privatelink.documents.azure.us"
  resource_group_name = local.resource_group_name
  tags                = merge({ "Name" = format("%s", "Azure-Cosmos-Db-Private-DNS-Zone") }, var.add_tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  count                 = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                  = "vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.dns_zone.0.name : var.existing_private_dns_zone
  virtual_network_id    = data.azurerm_virtual_network.vnet.0.id
  registration_enabled  = false
  tags                  = merge({ "Name" = format("%s", "vnet-private-zone-link") }, var.add_tags, )
}

resource "azurerm_private_dns_a_record" "a_rec" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = lower(element([for n in azurerm_cosmosdb_account.db : n.name], 0))
  zone_name           = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.dns_zone.0.name : var.existing_private_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.pip.0.private_service_connection.0.private_ip_address]
}