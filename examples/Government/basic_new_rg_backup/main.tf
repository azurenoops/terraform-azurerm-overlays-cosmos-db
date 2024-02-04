# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_cosmos_db" {
  #source  = "azurenoops/overlays-cosmos-db/azurerm"
  #version = "x.x.x"
  source = "../../.."

  # Resource Group, location, VNet and Subnet details
  create_cosmos_db_resource_group = true
  location                        = var.location
  deploy_environment              = var.deploy_environment
  environment                     = var.environment
  org_name                        = var.org_name
  workload_name                   = var.workload_name

  # Backup details
   backup = {
    type                = "Periodic"
    interval_in_minutes = 60 * 3 # 3 hours
    retention_in_hours  = 24
  }
  
  # Tags
  add_tags = {
    Example = "basic_new_rg_backup"
  }
}
