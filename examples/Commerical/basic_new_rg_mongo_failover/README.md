# Azure Cosmos DB Overlay Terraform Module

This terraform overlay module deploys an Cosmos DB with MongoDB enabled and failover.

## Module Usage for Cosmos DB with MongoDB enabled and failover

```terraform
# Azurerm provider configuration
provider "azurerm" {
  environment = "public"
  features {}
}

module "mod_cosmos_db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"

  # Resource Group, location, VNet and Subnet details
  create_cosmos_db_resource_group = true
  location                        = var.location
  deploy_environment              = var.deploy_environment
  environment                     = var.environment
  org_name                        = var.org_name
  workload_name                   = var.workload_name

  # Cosmos DB details
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities = [ "EnableMongo", "EnableAggregationPipeline", "mongoEnableDocLevelTTL", "MongoDBv3.4" ]

  # Consistency policy
  consistency_policy_level                 = "BoundedStaleness"
  consistency_policy_max_interval_in_seconds = 300
  consistency_policy_max_staleness_prefix    = 100000

  # Failover locations
  failover_locations = [
    {
      location       = "eastus"
      priority       = 0
      zone_redundant = false
    },
    {
      location       = "westus"
      priority       = 1
      zone_redundant = false
    }
  ]

  # Tags
  add_tags = {
    Example = "basic_new_rg_mongo_failover"
  }
}
```

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.
