# Azure Cosmos DB Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-cosmos-db/azurerm/)

This Overlay terraform module creates an [Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction) account with CosmosDB table, SQL database and SQL Containers resources to be used in a [SCCA compliant Management Network](https://registry.terraform.io/modules/azurenoops/overlays-management-hub/azurerm/latest).

## Using Azure Clouds

Since this module is built for both public and us government clouds. The `environment` variable defaults to `public` for Azure Cloud. When using this module with the Azure Government Cloud, you must set the `environment` variable to `usgovernment`. You will also need to set the azurerm provider `environment` variable to the proper cloud as well. This will ensure that the correct Azure Government Cloud endpoints are used. You will also need to set the `location` variable to a valid Azure Government Cloud location.

Example Usage for Azure Government Cloud:

```hcl

provider "azurerm" {
  environment = "usgovernment"
}

module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  location = "usgovvirginia"
  environment = "usgovernment"
  ...
}

```

### Resource Provider List

Terraform requires the following resource providers to be available:

- Microsoft.Network
- Microsoft.Storage
- Microsoft.Compute
- Microsoft.KeyVault
- Microsoft.Authorization
- Microsoft.Resources
- Microsoft.OperationalInsights
- Microsoft.GuestConfiguration
- Microsoft.Insights
- Microsoft.Advisor
- Microsoft.Security
- Microsoft.OperationsManagement
- Microsoft.AAD
- Microsoft.AlertsManagement
- Microsoft.Authorization
- Microsoft.AnalysisServices
- Microsoft.Automation
- Microsoft.Subscription
- Microsoft.Support
- Microsoft.PolicyInsights
- Microsoft.SecurityInsights
- Microsoft.Security
- Microsoft.Monitor
- Microsoft.Management
- Microsoft.ManagedServices
- Microsoft.ManagedIdentity
- Microsoft.Billing
- Microsoft.Consumption

Please note that some of the resource providers may not be available in Azure Government Cloud. Please check the [Azure Government Cloud documentation](https://docs.microsoft.com/en-us/azure/azure-government/documentation-government-get-started-connect-with-cli) for more information.

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Resources supported

- [CosmosDB Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account)
- [CosmosDB Table within a Cosmos DB Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_table)
- [SQL Database within a Cosmos DB Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database)
- [SQL Container within a Cosmos DB Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container)
- [Threat protection for Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/cosmos-db-advanced-threat-protection?tabs=azure-portal)
- [Private Endpoints](https://www.terraform.io/docs/providers/azurerm/r/private_endpoint.html)
- [Private DNS zone for `privatelink` A records](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)

## Module Usage

```terraform
# Azurerm provider configuration
provider "azurerm" {
  features {}
}

module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"  
}
```

## Create resource group

By default, this module will create a resource group by setting the argument to `create_cosmos_db_resource_group = true`. To use a custom name of the resource group use argument `custom_resource_group_name` located in `variables.naming.tf`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_cosmos_db_resource_group = false` and argument `existing_resource_group_name`.

> **Note:** *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Configuing Cosmos Db with Backup

Azure Cosmos DB automatically takes a full backup of your database every 4 hours and at any point of time, only the latest two backups are stored by default. If the default intervals aren't sufficient for your workloads, you can change the backup interval and the retention period using `bakup` object it supports following.

Name | Description
---- | -----------
`type`|The `type` of the backup. Possible values are `Continuous` and `Periodic`. Defaults to `Periodic`.
`interval_in_minutes`|The interval in minutes between two backups. This is configurable only when type is `Periodic`. Possible values are between `60` and `1440`.
`retention_in_hours`|The time in hours that each backup is retained. This is configurable only when type is `Periodic`. Possible values are between `8` and `720`.

### Use with Backup

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      backup = {
        type                = "Periodic"
        interval_in_minutes = 60 * 3 # 3 hours
        retention_in_hours  = 24
      }
    }
  }
}
```

## Configuing Cosmos Db with Analytical Storage

To configure analytical storage for the Cosmos Db, set the `enable_analytical_storage` variable to `true`. This will enable analytical storage for the Cosmos Db. Set the `analytical_storage_type` variable to `FullFidelity` and `WellDefined` to use the analytical storage with the Cosmos Db.

### Use with Analytical Storage

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

     # Analytical Storage Configuration
     enable_analytical_storage = true
     analytical_storage_type = "FullFidelity"
    }
  }  
}
```

## Configuing Cosmos Db with Consistency Policy

Distributed databases that rely on replication for high availability, low latency, or both, must make a fundamental tradeoff between the read consistency, availability, latency, and throughput as defined by the PACLC theorem. Azure Cosmos DB offers five well-defined levels. From strongest to weakest, the levels are: Strong, Bounded staleness, Session, Consistent prefix, Eventual. The consistency levels are region-agnostic and are guaranteed for all operations regardless of the region from which the reads and writes are served, the number of regions associated with your Azure Cosmos account, or whether your account is configured with a single or multiple write regions.

This option is not enabled by default and can be included in the terraform plan by specifiing following arguments with `consistency_policy` object.

Name | Description
---- | -----------
`consistency_level`|The Consistency Level to use for this CosmosDB Account - can be either `BoundedStaleness`, `Eventual`, `Session`, `Strong` or `ConsistentPrefix`.
`max_interval_in_seconds`|When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Accepted range for this value is `5` - `86400` (1 day). Defaults to `5`. Required when `consistency_level` is set to `BoundedStaleness`.
`max_staleness_prefix`|When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Accepted range for this value is `10` – `2147483647`. Defaults to `100`. Required when `consistency_level` is set to `BoundedStaleness`.

> [!NOTE]
> `max_interval_in_seconds` and `max_staleness_prefix` can only be set to custom values when `consistency_level` is set to `BoundedStaleness` - otherwise they will return the default values shown above.

### Use with Consistency Policy

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # Consistency Policy Configuration
      # `max_staleness_prefix` must be greater then `100000` when more then one geo_location is used
      # `max_interval_in_seconds` must be greater then 300 (5min) when more then one geo_location is used
      consistency_policy = {
        consistency_level       = "BoundedStaleness"
        max_staleness_prefix    = 100000
        max_interval_in_seconds = 300
      }
    }
  }    
}
```

## Configuing Cosmos Db with Geo Locations

Azure Cosmos DB is a globally distributed database system that allows you to read and write data from the local replicas of your database. Azure Cosmos DB transparently replicates the data to all the regions associated with your Cosmos account.

This option is not enabled by default and can be included in the terraform plan by specifiing following arguments with `failover_locations` object.

Name | Description
---- | -----------
`location`|The name of the Azure region to host replicated data.
`failover_priority`|The failover priority of the region. A failover priority of `0` indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists. Changing this causes the location to be re-provisioned and cannot be changed for the location with failover priority `0`.
`zone_redundant`|Should zone redundancy be enabled for this region? Defaults to `false`.

### Distribute your data globally

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # Configures the geographic locations the data is replicated
      # Location prefix (key) must be 3 - 50 characters long, contain only lowercase letters, numbers and hyphyens 
      # Uncomment when want to use failover locations
      failover_locations = [
        {
          location          = "southcentralus"
          failover_priority = 0
          zone_redundant    = false
        }
      ]
    }
  }    
}
```

## Configuing Cosmos Db with Failover Locations

To configure failover locations for the Cosmos Db, set the `failover_locations` variable to a list of failover locations. This will enable failover locations for the Cosmos Db. Set the `location_name` and `priority` keys to use the failover locations with the Cosmos Db. The priority value must be unique for each failover location. The priority value must be between 0 and 4. If `failover_locations` variable is not set, the Cosmos Db module will be created with a single region.

### Use with Failover Locations

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

     # Failover Locations Configuration
     failover_locations = [
        {
          location_name = "eastus"
          priority      = 0
        },
        {
          location_name = "westus"
          priority      = 1
        }
      ]
    }
  }    
}
```

## Configuing Cosmos Db with Capabilities

This option is not enabled by default and can be included in the terraform plan by specifiing `capabilities` with a valid list of strings. Accepted values are `AllowSelfServeUpgradeToMongo36`, `DisableRateLimitingResponses`, `EnableAggregationPipeline`, `EnableCassandra`, `EnableGremlin`, `EnableMongo`, `EnableTable`, `EnableServerless`, `MongoDBv3.4` and `mongoEnableDocLevelTTL`.

### Use with Capabilities

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # Capibilities Configuration
      capabilities = ["EnableCassandra", "EnableGremlin"]
    }
  } 
}
```

## Configuing Cosmos Db with Virutal Network Rules

To configure virtual network rules for the Cosmos Db, set the `virtual_network_rules` variable to a list of virtual network rules. This will enable virtual network rules for the Cosmos Db. Set the `subnet_id` and `ignore_missing_vnet_service_endpoint` keys to use the virtual network rules with the Cosmos Db.

### Use with Virtual Network Rules

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # Virtual Network Rules Configuration
      virtual_network_rules = [
        {
          subnet_id = "<subnet_id>"
          ignore_missing_vnet_service_endpoint = true
        }
      ]
    }
  } 
}
```

## Using Cosmos Db with User Assigned Identity

To use a user assigned identity with the Cosmos Db module, set the `identity_type` variable to `UserAssigned`. Add the `existing_principal_ids` variable to the module and set it to the user assigned identity ids. The user assigned identity must be in the same region and subscription where the Cosmos Db resides.

### Use with User Assigned Identity

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # User Assigned Identity Configuration
      identity_type = "UserAssigned"
      existing_principal_ids = ["<user_assigned_identity_ids>"]
    }
  }
}
```

## Enabling Cosmos Db to use Customer Managed Key

Data stored in your Azure Cosmos account is automatically and seamlessly encrypted with keys managed by Microsoft (service-managed keys). Optionally, you can choose to add a second layer of encryption with keys you manage (customer-managed keys).

> [!NOTE]
> Currently, customer-managed keys are available only for new Azure Cosmos accounts. You should configure them during account creation.
> When referencing an `key_vault_key_id` in the module, use `versionless_id` instead of `id`

### Use with Customer Managed Key

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # Customer Managed Key Configuration
      key_vault_key_id = "<key_vault_id>"
    }
  } 
}
```

## Enabling Cosmos Db to use Mongo Db

To enable Cosmos Db to use Mongo Db, set the `kind` variable to `MongoDB`. This will enable Mongo Db for the Cosmos Db. Set the `capabilities` variable to `EnableMongo` to use the Mongo Db with the Cosmos Db.

> **Note**: The default Mongo version is 4.2. To use a different version, set the `mongo_server_version` variable to the desired version.

### Use with Mongo Db

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_cosmos_db_resource_group  = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      
      # Mongo Db Configuration
      kind  = "MongoDB"
      capabilities  = ["EnableMongo"]
    }
  }   
}
```

## Recommended naming and tagging conventions

Applying tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair. For example, you can apply the name `Environment` and the value `Production` to all the resources in production.
For recommendations on how to implement a tagging strategy, see Resource naming and tagging decision guide.

>**Important** :
Tag names are case-insensitive for operations. A tag with a tag name, regardless of the casing, is updated or retrieved. However, the resource provider might keep the casing you provide for the tag name. You'll see that casing in cost reports. **Tag values are case-sensitive.**

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0.4 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_azregions"></a> [mod\_azregions](#module\_mod\_azregions) | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_scaffold_rg"></a> [mod\_scaffold\_rg](#module\_mod\_scaffold\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_advanced_threat_protection.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_cosmosdb_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_sql_container.sql_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_cosmosdb_table.table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_table) | resource |
| [azurerm_private_dns_a_record.a_rec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurenoopsutils_resource_name.cosmosdb](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_endpoint_connection.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_analytical_storage_ttl"></a> [analytical\_storage\_ttl](#input\_analytical\_storage\_ttl) | The default time to live of Analytical Storage for this SQL container. If present and the value is set to `-1`, it is equal to infinity, and items don’t expire by default. If present and the value is set to some number `n` – items will expire `n2` seconds after their last modified time. | `any` | `null` | no |
| <a name="input_conflict_resolution_policy"></a> [conflict\_resolution\_policy](#input\_conflict\_resolution\_policy) | Conflicts and conflict resolution policies are applicable if your Azure Cosmos DB account is configured with multiple write regions | <pre>object({<br>    mode                          = string<br>    conflict_resolution_path      = string<br>    conflict_resolution_procedure = string<br>  })</pre> | `null` | no |
| <a name="input_container_indexing_policy"></a> [container\_indexing\_policy](#input\_container\_indexing\_policy) | Specifies how the container's items should be indexed. The default indexing policy for newly created containers indexes every property of every item and enforces range indexes for any string or number | <pre>object({<br>    indexing_mode = optional(string)<br>    included_path = optional(object({<br>      path = string<br>    }))<br>    excluded_path = optional(object({<br>      path = string<br>    }))<br>    composite_index = optional(object({<br>      index = optional(object({<br>        path  = string<br>        order = string<br>      }))<br>    }))<br>    spatial_index = optional(object({<br>      path = string<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_cosmosdb_account"></a> [cosmosdb\_account](#input\_cosmosdb\_account) | Manages a CosmosDB (formally DocumentDB) Account specifications | <pre>map(object({<br>    offer_type                            = optional(string, "Standard")<br>    kind                                  = optional(string, "GlobalDocumentDB")<br>    enable_free_tier                      = optional(bool, false)<br>    analytical_storage_enabled            = optional(bool, false)<br>    enable_automatic_failover             = optional(bool, true)<br>    public_network_access_enabled         = optional(bool, true)<br>    is_virtual_network_filter_enabled     = optional(bool, false)<br>    key_vault_key_id                      = optional(string, null)<br>    enable_multiple_write_locations       = optional(bool, false)<br>    access_key_metadata_writes_enabled    = optional(bool, false)<br>    mongo_server_version                  = optional(string, "4.2")<br>    network_acl_bypass_for_azure_services = optional(bool, false)<br>    network_acl_bypass_ids                = optional(list(string), null)<br>    enable_analytical_storage             = optional(bool, false)<br>    analytical_storage_type               = optional(string, null)<br>    managed_identity                      = optional(bool, false)<br>    identity_type                         = optional(string, "SystemAssigned")<br>    existing_principal_ids                = optional(list(string), null)<br>    default_identity_type                 = optional(string, "FirstPartyIdentity")<br>    consistency_policy = optional(object({<br>      consistency_level       = string<br>      max_interval_in_seconds = optional(number, 5)<br>      max_staleness_prefix    = optional(number, 100)<br>    })),<br>    failover_locations = optional(list(object({<br>      location          = string<br>      failover_priority = number<br>      zone_redundant    = optional(bool)<br>    }))),<br>    capabilities           = optional(list(string), []),<br>    allowed_ip_range_cidrs = optional(list(string), []),<br>    virtual_network_rules = optional(list(object({<br>      subnet_id                            = string<br>      ignore_missing_vnet_service_endpoint = optional(bool, false)<br>    }))),<br>    cors_rules = optional(object({<br>      allowed_headers    = list(string)<br>      allowed_methods    = list(string)<br>      allowed_origins    = list(string)<br>      exposed_headers    = list(string)<br>      max_age_in_seconds = number<br>    })),<br>  }))</pre> | n/a | yes |
| <a name="input_cosmosdb_sqldb_autoscale_settings"></a> [cosmosdb\_sqldb\_autoscale\_settings](#input\_cosmosdb\_sqldb\_autoscale\_settings) | The maximum throughput of the Table (RU/s). Must be between `4,000` and `1,000,000`. Must be set in increments of `1,000`. Conflicts with `throughput`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. | <pre>object({<br>    max_throughput = string<br>  })</pre> | `null` | no |
| <a name="input_cosmosdb_sqldb_throughput"></a> [cosmosdb\_sqldb\_throughput](#input\_cosmosdb\_sqldb\_throughput) | The throughput of Table (RU/s). Must be set in increments of `100`. The minimum value is `400`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. | `number` | `400` | no |
| <a name="input_cosmosdb_table_autoscale_settings"></a> [cosmosdb\_table\_autoscale\_settings](#input\_cosmosdb\_table\_autoscale\_settings) | The maximum throughput of the Table (RU/s). Must be between `4,000` and `1,000,000`. Must be set in increments of `1,000`. Conflicts with `throughput`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. | <pre>object({<br>    max_throughput = string<br>  })</pre> | `null` | no |
| <a name="input_cosmosdb_table_throughput"></a> [cosmosdb\_table\_throughput](#input\_cosmosdb\_table\_throughput) | The throughput of Table (RU/s). Must be set in increments of `100`. The minimum value is `400`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. | `any` | `null` | no |
| <a name="input_create_cosmos_db_resource_group"></a> [create\_cosmos\_db\_resource\_group](#input\_create\_cosmos\_db\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_create_cosmosdb_sql_container"></a> [create\_cosmosdb\_sql\_container](#input\_create\_cosmosdb\_sql\_container) | Manages a SQL Container within a Cosmos DB Account | `bool` | `false` | no |
| <a name="input_create_cosmosdb_sql_database"></a> [create\_cosmosdb\_sql\_database](#input\_create\_cosmosdb\_sql\_database) | Manages a SQL Database within a Cosmos DB Account | `bool` | `false` | no |
| <a name="input_create_cosmosdb_table"></a> [create\_cosmosdb\_table](#input\_create\_cosmosdb\_table) | Manages a Table within a Cosmos DB Account | `bool` | `false` | no |
| <a name="input_create_private_endpoint_subnet"></a> [create\_private\_endpoint\_subnet](#input\_create\_private\_endpoint\_subnet) | Controls if the subnet should be created. If set to false, the subnet name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_custom_cosmosdb_name"></a> [custom\_cosmosdb\_name](#input\_custom\_cosmosdb\_name) | The name of the custom Cosmos DB to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_cosmosdb_sql_container_name"></a> [custom\_cosmosdb\_sql\_container\_name](#input\_custom\_cosmosdb\_sql\_container\_name) | The name of the custom Cosmos DB sql container. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `any` | `null` | no |
| <a name="input_custom_cosmosdb_sql_database_name"></a> [custom\_cosmosdb\_sql\_database\_name](#input\_custom\_cosmosdb\_sql\_database\_name) | The name of the custom Cosmos DB SQL database. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `any` | `null` | no |
| <a name="input_custom_cosmosdb_table_name"></a> [custom\_cosmosdb\_table\_name](#input\_custom\_cosmosdb\_table\_name) | The name of the custom Cosmos DB Table API. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `any` | `null` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | The default time to live of SQL container. If missing, items are not expired automatically. If present and the value is set to `-1`, it is equal to infinity, and items don’t expire by default. If present and the value is set to some number `n` – items will expire `n` seconds after their last modified time. | `any` | `null` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environment | `string` | n/a | yes |
| <a name="input_enable_advanced_threat_protection"></a> [enable\_advanced\_threat\_protection](#input\_enable\_advanced\_threat\_protection) | Enables Advanced Threat Protection for Azure Cosmos DB. Default is false. | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Manages a Private Endpoint to Azure Container Registry. Default is false. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_existing_private_dns_zone"></a> [existing\_private\_dns\_zone](#input\_existing\_private\_dns\_zone) | Name of the existing private DNS zone | `any` | `null` | no |
| <a name="input_existing_private_subnet_name"></a> [existing\_private\_subnet\_name](#input\_existing\_private\_subnet\_name) | Name of the existing subnet for the private endpoint | `any` | `null` | no |
| <a name="input_existing_private_virtual_network_name"></a> [existing\_private\_virtual\_network\_name](#input\_existing\_private\_virtual\_network\_name) | Name of the existing virtual network for the private endpoint | `any` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_partition_key_path"></a> [partition\_key\_path](#input\_partition\_key\_path) | Define a partition key | `string` | `"/definition/id"` | no |
| <a name="input_partition_key_version"></a> [partition\_key\_version](#input\_partition\_key\_version) | Define a partition key version. Possible values are `1` and `2`. This should be set to `2` in order to use large partition keys. | `number` | `1` | no |
| <a name="input_private_subnet_address_prefix"></a> [private\_subnet\_address\_prefix](#input\_private\_subnet\_address\_prefix) | The name of the subnet for private endpoints | `any` | `null` | no |
| <a name="input_resource_types"></a> [resource\_types](#input\_resource\_types) | The Azure Cosmos DB API type that you want to map for the private endpoint. This defaults to only one choice for the APIs for `SQL`, `MongoDB`, and `Cassandra`. Defaults to `Sql`. For the APIs for Gremlin and Table, you can also choose `NoSQL` because these APIs are interoperable with the API for `NoSQL`. | `list(string)` | <pre>[<br>  "Sql"<br>]</pre> | no |
| <a name="input_sql_container_autoscale_settings"></a> [sql\_container\_autoscale\_settings](#input\_sql\_container\_autoscale\_settings) | The maximum throughput of the Table (RU/s). Must be between `4,000` and `1,000,000`. Must be set in increments of `1,000`. Conflicts with `throughput`. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. | <pre>object({<br>    max_throughput = string<br>  })</pre> | `null` | no |
| <a name="input_sql_container_throughput"></a> [sql\_container\_throughput](#input\_sql\_container\_throughput) | The throughput of SQL container (RU/s). Must be set in increments of `100`. The minimum value is `400`. This must be set upon container creation otherwise it cannot be updated without a manual terraform destroy-apply | `any` | `null` | no |
| <a name="input_unique_key"></a> [unique\_key](#input\_unique\_key) | A list of paths to use for this unique key | <pre>object({<br>    paths = list(string)<br>  })</pre> | `null` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cosmosdb_connection_strings"></a> [cosmosdb\_connection\_strings](#output\_cosmosdb\_connection\_strings) | A list of connection strings available for this CosmosDB account |
| <a name="output_cosmosdb_endpoint"></a> [cosmosdb\_endpoint](#output\_cosmosdb\_endpoint) | The endpoint used to connect to the CosmosDB account. |
| <a name="output_cosmosdb_id"></a> [cosmosdb\_id](#output\_cosmosdb\_id) | The CosmosDB Account resource ID. |
| <a name="output_cosmosdb_primary_key"></a> [cosmosdb\_primary\_key](#output\_cosmosdb\_primary\_key) | The Primary master key for the CosmosDB Account |
| <a name="output_cosmosdb_primary_readonly_key"></a> [cosmosdb\_primary\_readonly\_key](#output\_cosmosdb\_primary\_readonly\_key) | The Primary read-only master Key for the CosmosDB Account |
| <a name="output_cosmosdb_private_dns_zone_domain"></a> [cosmosdb\_private\_dns\_zone\_domain](#output\_cosmosdb\_private\_dns\_zone\_domain) | DNS zone name of Cosmosdb Account Private endpoints dns name records |
| <a name="output_cosmosdb_private_endpoint"></a> [cosmosdb\_private\_endpoint](#output\_cosmosdb\_private\_endpoint) | id of the Cosmosdb Account Private Endpoint |
| <a name="output_cosmosdb_private_endpoint_fqdn"></a> [cosmosdb\_private\_endpoint\_fqdn](#output\_cosmosdb\_private\_endpoint\_fqdn) | CosmosDB account server private endpoint FQDN Addresses |
| <a name="output_cosmosdb_private_endpoint_ip"></a> [cosmosdb\_private\_endpoint\_ip](#output\_cosmosdb\_private\_endpoint\_ip) | CosmosDB account private endpoint IPv4 Addresses |
| <a name="output_cosmosdb_read_endpoints"></a> [cosmosdb\_read\_endpoints](#output\_cosmosdb\_read\_endpoints) | A list of read endpoints available for this CosmosDB account |
| <a name="output_cosmosdb_secondary_key"></a> [cosmosdb\_secondary\_key](#output\_cosmosdb\_secondary\_key) | The Secondary master key for the CosmosDB Account. |
| <a name="output_cosmosdb_secondary_readonly_key"></a> [cosmosdb\_secondary\_readonly\_key](#output\_cosmosdb\_secondary\_readonly\_key) | The Secondary read-only master key for the CosmosDB Account |
| <a name="output_cosmosdb_write_endpoints"></a> [cosmosdb\_write\_endpoints](#output\_cosmosdb\_write\_endpoints) | A list of write endpoints available for this CosmosDB account. |
<!-- END_TF_DOCS -->