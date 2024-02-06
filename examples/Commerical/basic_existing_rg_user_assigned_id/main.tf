# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_cosmos_db" {
  #source  = "azurenoops/overlays-cosmos-db/azurerm"
  #version = "x.x.x"
  source = "../../.."

  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = azurerm_resource_group.cosmos-db-rg.name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  environment                  = var.environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

  # Cosmos DB details
  offer_type = "Standard"
  kind       = "MongoDB"

  capabilities = ["EnableMongo"]

  # Consistency policy
  consistency_policy_level = "Strong"

  # Identity
  default_identity_type  = "UserAssignedIdentity"
  identity_type          = "UserAssigned"
  existing_principal_ids = ["${azurerm_user_assigned_identity.cosmos-db-id.id}"]

  # Tags
  add_tags = {
    Example = "basic_existing_rg_user_assigned_id"
  }
}
