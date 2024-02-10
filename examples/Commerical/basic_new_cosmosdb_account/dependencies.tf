# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

 resource "azurerm_resource_group" "cosmos-db-network-rg" {
  name     = "cosmos-db-network-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "cosmos-db-vnet" {
  depends_on = [
    azurerm_resource_group.cosmos-db-network-rg
  ]
  name                = "cosmos-db-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.cosmos-db-network-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "cosmos-db-snet" {
  depends_on = [
    azurerm_resource_group.cosmos-db-network-rg,
    azurerm_virtual_network.cosmos-db-vnet
  ]
  name                 = "cosmos-db-subnet"
  resource_group_name  = azurerm_resource_group.cosmos-db-network-rg.name
  virtual_network_name = azurerm_virtual_network.cosmos-db-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "cosmos-db-nsg" {
  depends_on = [
    azurerm_resource_group.cosmos-db-network-rg,
  ]
  name                = "cosmos-db-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.cosmos-db-network-rg.name
  tags = {
    environment = "test"
  }
}

