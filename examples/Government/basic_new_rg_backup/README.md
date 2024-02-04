# Azure Cosmos DB Overlay Terraform Module

This terraform overlay module deploys an Cosmos DB with backup.

## Module Usage for Cosmos DB with backup

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
```

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.
