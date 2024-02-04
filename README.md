# Azure Cosmos DB Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-cosmos-db/azurerm/)

This Overlay terraform module creates an [Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction) to be used in a [SCCA compliant Management Network](https://registry.terraform.io/modules/azurenoops/overlays-management-hub/azurerm/latest).

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

## Resources Supported

- [Azure Cosmos Db]()
-

## Module Usage

```terraform
# Azurerm provider configuration
provider "azurerm" {
  features {}
}

module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"  
}
```

## Configuing Cosmos Db with Backup

To configure backup policy for the Cosmos Db, set the `backup` variable block with type (Continuous / Periodic), interval_in_minutes and retention_in_hours keys. This will enable backup for the Cosmos Db.

### Use with Backup

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  backup = {
    type                = "Periodic"
    interval_in_minutes = 60 * 3 # 3 hours
    retention_in_hours  = 24
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
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Analytical Storage Configuration
  enable_analytical_storage = true
  analytical_storage_type = "FullFidelity"
}
```

## Configuing Cosmos Db with Failover Locations

To configure failover locations for the Cosmos Db, set the `failover_locations` variable to a list of failover locations. This will enable failover locations for the Cosmos Db. Set the `location_name` and `priority` keys to use the failover locations with the Cosmos Db. The priority value must be unique for each failover location. The priority value must be between 0 and 4. If `failover_locations` variable is not set, the Cosmos Db module will be created with a single region.

### Use with Failover Locations

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

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
```

## Configuing Cosmos Db with Capabilities

To configure capabilities for the Cosmos Db, set the `capabilities` variable to a list of capabilities. This will enable capabilities for the Cosmos Db. Possible values for capabilities are `AllowSelfServeUpgradeToMongo36`, `DisableRateLimitingResponses`, `EnableAggregationPipeline`, `EnableCassandra`, `EnableGremlin` , `EnableMongo`, `EnableTable`, `EnableServerless`, `MongoDBv3.4` and `mongoEnableDocLevelTTL`.

### Use with Capabilities

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Capibilities Configuration
  capabilities = ["EnableCassandra", "EnableGremlin"]
}
```

## Configuing Cosmos Db with Virutal Network Rules

To configure virtual network rules for the Cosmos Db, set the `virtual_network_rules` variable to a list of virtual network rules. This will enable virtual network rules for the Cosmos Db. Set the `subnet_id` and `ignore_missing_vnet_service_endpoint` keys to use the virtual network rules with the Cosmos Db.

### Use with Virtual Network Rules

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Virtual Network Rules Configuration
  virtual_network_rules = [
    {
      subnet_id = "<subnet_id>"
      ignore_missing_vnet_service_endpoint = true
    }
  ]
}
```

## Using Cosmos Db with User Assigned Identity

To use a user assigned identity with the Cosmos Db module, set the `identity_type` variable to `UserAssigned`. Add the `existing_principal_ids` variable to the module and set it to the user assigned identity ids. The user assigned identity must be in the same region and subscription where the Cosmos Db resides.

### Use with User Assigned Identity

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"
  
  # User Assigned Identity Configuration
  identity_type = "UserAssigned"
  existing_principal_ids = ["<user_assigned_identity_ids>"]
}
```

## Enabling Cosmos Db to use Customer Managed Key

To enable Cosmos Db to use customer managed key, set the `key_vault_key_id` variable to the key vault key id. This will enable customer managed key for the Cosmos Db. The key vault must be in the same region and subscription where the Cosmos Db resides.

### Use with Customer Managed Key

```terraform
module "overlays-cosmos-db" {
  source  = "azurenoops/overlays-cosmos-db/azurerm"
  version = "x.x.x"
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Customer Managed Key Configuration
  key_vault_key_id = "<key_vault_id>"
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
  
  create_app_config_resource_group = true
  location                         = "eastus"
  deploy_environment               = "dev"
  org_name                         = "anoa"
  environment                      = "public"
  workload_name                    = "cosmos-db"

  # Mongo Db Configuration
  kind  = "MongoDB"
  capabilities  = ["EnableMongo"]
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
| [azurerm_cosmosdb_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_management_lock.cosmos_db_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurenoopsutils_resource_name.cosmosdb](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | CosmosDB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account. | `list(string)` | `[]` | no |
| <a name="input_analytical_storage_type"></a> [analytical\_storage\_type](#input\_analytical\_storage\_type) | The schema type of the Analytical Storage for this Cosmos DB account. Possible values are `FullFidelity` and `WellDefined`. | `string` | `null` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | Backup block with type (Continuous / Periodic), interval\_in\_minutes and retention\_in\_hours keys | <pre>object({<br>    type                = string<br>    interval_in_minutes = number<br>    retention_in_hours  = number<br>  })</pre> | <pre>{<br>  "interval_in_minutes": 180,<br>  "retention_in_hours": 168,<br>  "type": "Periodic"<br>}</pre> | no |
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | Configures the capabilities to enable for this Cosmos DB account:<br>Possible values are<br>  AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses,<br>  EnableAggregationPipeline, EnableCassandra, EnableGremlin,EnableMongo, EnableTable, EnableServerless,<br>  MongoDBv3.4 and mongoEnableDocLevelTTL. | `list(string)` | `[]` | no |
| <a name="input_consistency_policy_level"></a> [consistency\_policy\_level](#input\_consistency\_policy\_level) | Consistency policy level. Allowed values are `BoundedStaleness`, `Eventual`, `Session`, `Strong` or `ConsistentPrefix` | `string` | `"BoundedStaleness"` | no |
| <a name="input_consistency_policy_max_interval_in_seconds"></a> [consistency\_policy\_max\_interval\_in\_seconds](#input\_consistency\_policy\_max\_interval\_in\_seconds) | When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Accepted range for this value is 5 - 86400 (1 day). Defaults to 5. Required when consistency\_level is set to BoundedStaleness. | `number` | `10` | no |
| <a name="input_consistency_policy_max_staleness_prefix"></a> [consistency\_policy\_max\_staleness\_prefix](#input\_consistency\_policy\_max\_staleness\_prefix) | When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Accepted range for this value is 10 – 2147483647. Defaults to 100. Required when consistency\_level is set to BoundedStaleness. | `number` | `200` | no |
| <a name="input_create_cosmos_db_resource_group"></a> [create\_cosmos\_db\_resource\_group](#input\_create\_cosmos\_db\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_create_private_endpoint_subnet"></a> [create\_private\_endpoint\_subnet](#input\_create\_private\_endpoint\_subnet) | Controls if the subnet should be created. If set to false, the subnet name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_custom_cosmosdb_name"></a> [custom\_cosmosdb\_name](#input\_custom\_cosmosdb\_name) | The name of the custom cosmosdb to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_default_identity_type"></a> [default\_identity\_type](#input\_default\_identity\_type) | The default identity type to use for the Cosmos DB account. Possible values are `FirstPartyIdentity` `SystemAssignedIdentity` and `UserAssignedIdentity`. | `string` | `"FirstPartyIdentity"` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | Name of the workload's environment | `string` | n/a | yes |
| <a name="input_enable_analytical_storage"></a> [enable\_analytical\_storage](#input\_enable\_analytical\_storage) | Enable Analytical Storage option for this Cosmos DB account. Defaults to `false`. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_enable_free_tier"></a> [enable\_free\_tier](#input\_enable\_free\_tier) | Enable the option to opt-in for the free database account within subscription. | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Manages a Private Endpoint to Azure Container Registry. Default is false. | `bool` | `false` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| <a name="input_enable_zone_redundancy"></a> [enable\_zone\_redundancy](#input\_enable\_zone\_redundancy) | True to enabled zone redundancy on default primary location | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| <a name="input_existing_principal_ids"></a> [existing\_principal\_ids](#input\_existing\_principal\_ids) | The principal ID of an existing principal ids to use for App Configuration. | `list(string)` | `null` | no |
| <a name="input_existing_private_dns_zone"></a> [existing\_private\_dns\_zone](#input\_existing\_private\_dns\_zone) | Name of the existing private DNS zone | `any` | `null` | no |
| <a name="input_existing_private_subnet_name"></a> [existing\_private\_subnet\_name](#input\_existing\_private\_subnet\_name) | Name of the existing subnet for the private endpoint | `any` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_failover_locations"></a> [failover\_locations](#input\_failover\_locations) | The name of the Azure region to host replicated data and their priority. | `map(map(string))` | `null` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | App configuration identity type. Possible values are `null` `UserAssigned` and `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| <a name="input_is_virtual_network_filter_enabled"></a> [is\_virtual\_network\_filter\_enabled](#input\_is\_virtual\_network\_filter\_enabled) | Enables virtual network filtering for this Cosmos DB account | `bool` | `false` | no |
| <a name="input_key_vault_key_id"></a> [key\_vault\_key\_id](#input\_key\_vault\_key\_id) | The Key Vault Key ID for the encryption key to use for the account. | `string` | `null` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`. | `string` | `"GlobalDocumentDB"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region in which instance will be hosted | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_mongo_server_version"></a> [mongo\_server\_version](#input\_mongo\_server\_version) | The Server Version of a MongoDB account. See possible values https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account#mongo_server_version | `string` | `"4.2"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_network_acl_bypass_for_azure_services"></a> [network\_acl\_bypass\_for\_azure\_services](#input\_network\_acl\_bypass\_for\_azure\_services) | If azure services can bypass ACLs. | `bool` | `false` | no |
| <a name="input_network_acl_bypass_ids"></a> [network\_acl\_bypass\_ids](#input\_network\_acl\_bypass\_ids) | The list of resource Ids for Network Acl Bypass for this Cosmos DB account. | `list(string)` | `null` | no |
| <a name="input_offer_type"></a> [offer\_type](#input\_offer\_type) | Specifies the Offer Type to use for this CosmosDB Account - currently this can only be set to Standard. | `string` | `"Standard"` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Name of the organization | `string` | n/a | yes |
| <a name="input_private_subnet_address_prefix"></a> [private\_subnet\_address\_prefix](#input\_private\_subnet\_address\_prefix) | The name of the subnet for private endpoints | `any` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this CosmosDB account. | `bool` | `true` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network for the private endpoint | `any` | `null` | no |
| <a name="input_virtual_network_rule"></a> [virtual\_network\_rule](#input\_virtual\_network\_rule) | Specifies a virtual\_network\_rules resource used to define which subnets are allowed to access this CosmosDB account | <pre>list(object({<br>    subnet_id                            = string,<br>    ignore_missing_vnet_service_endpoint = bool<br>  }))</pre> | `null` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cosmosdb_connection_strings"></a> [cosmosdb\_connection\_strings](#output\_cosmosdb\_connection\_strings) | A list of connection strings available for this CosmosDB account. |
| <a name="output_cosmosdb_endpoint"></a> [cosmosdb\_endpoint](#output\_cosmosdb\_endpoint) | The endpoint used to connect to the CosmosDB account. |
| <a name="output_cosmosdb_id"></a> [cosmosdb\_id](#output\_cosmosdb\_id) | The CosmosDB Account ID. |
| <a name="output_cosmosdb_name"></a> [cosmosdb\_name](#output\_cosmosdb\_name) | The CosmosDB Account Name. |
| <a name="output_cosmosdb_primary_master_key"></a> [cosmosdb\_primary\_master\_key](#output\_cosmosdb\_primary\_master\_key) | The Primary master key for the CosmosDB Account. |
| <a name="output_cosmosdb_primary_readonly_master_key"></a> [cosmosdb\_primary\_readonly\_master\_key](#output\_cosmosdb\_primary\_readonly\_master\_key) | The Primary read-only master Key for the CosmosDB Account. |
| <a name="output_cosmosdb_read_endpoints"></a> [cosmosdb\_read\_endpoints](#output\_cosmosdb\_read\_endpoints) | A list of read endpoints available for this CosmosDB account. |
| <a name="output_cosmosdb_secondary_master_key"></a> [cosmosdb\_secondary\_master\_key](#output\_cosmosdb\_secondary\_master\_key) | The Secondary master key for the CosmosDB Account. |
| <a name="output_cosmosdb_secondary_readonly_master_key"></a> [cosmosdb\_secondary\_readonly\_master\_key](#output\_cosmosdb\_secondary\_readonly\_master\_key) | The Secondary read-only master key for the CosmosDB Account. |
| <a name="output_cosmosdb_write_endpoints"></a> [cosmosdb\_write\_endpoints](#output\_cosmosdb\_write\_endpoints) | A list of write endpoints available for this CosmosDB account. |
| <a name="output_identity"></a> [identity](#output\_identity) | Identity block with principal ID |
<!-- END_TF_DOCS -->