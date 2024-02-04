# Azure Cosmos DB Overlay Terraform Module

This terraform overlay module deploys an Cosmos DB with MongoDB enabled and a User Assigned Identity.

## Module Usage for Cosmos DB with MongoDB enabled and a User Assigned Identity

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
  offer_type = "Standard"
  kind       = "MongoDB"

  capabilities = ["EnableMongo"]

  # Consistency policy
  consistency_policy_level                   = "Strong"

  # Identity
  default_identity_type  = "UserAssignedIdentity"
  identity_type          = "UserAssigned"
  existing_principal_ids = ["${azurerm_user_assigned_identity.cosmos-db-id.id}"]

  # Tags
  add_tags = {
    Example = "basic_existing_rg_user_assigned_id"
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
