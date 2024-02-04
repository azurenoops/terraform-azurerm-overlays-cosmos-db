# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_resource_group" "cosmos-db-rg" {
  name     = "cosmos-db-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_user_assigned_identity" "cosmos-db-id" {
  name                = "cosmos-db-identity"
  location            = azurerm_resource_group.cosmos-db-rg.location
  resource_group_name = azurerm_resource_group.cosmos-db-rg.name
}
