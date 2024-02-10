# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_cosmos_db" {
  #source  = "azurenoops/overlays-cosmos-db/azurerm"
  #version = "x.x.x"
  source = "../../.."

  depends_on = [
    azurerm_resource_group.cosmos-db-network-rg,
  ]

  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = azurerm_resource_group.cosmos-db-network-rg.name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  environment                  = var.environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

  # Cosmosdb account details.  
  cosmosdb_account = {
    demo = {
      # Currently Offer Type supports only be set to `Standard`
      # Specifies the Kind of CosmosDB to create - possible values are `GlobalDocumentDB` and `MongoDB`
      offer_type = "Standard"
      kind       = "GlobalDocumentDB"

      # `max_staleness_prefix` must be greater then `100000` when more then one geo_location is used
      # `max_interval_in_seconds` must be greater then 300 (5min) when more then one geo_location is used
      consistency_policy = {
        consistency_level       = "BoundedStaleness"
        max_staleness_prefix    = 100000
        max_interval_in_seconds = 300
      }

     # Configures the geographic locations the data is replicated
      # Location prefix (key) must be 3 - 50 characters long, contain only lowercase letters, numbers and hyphyens 
      # Uncomment when want to use failover locations
      /*  failover_locations = [
        {
          location          = "usgovarizonia"
          failover_priority = 0
          zone_redundant    = false
        }
      ] */

      # CosmosDB Firewall Support: Specifies the set of IP addresses / ranges to be included as an allowed list 
      # IP addresses/ranges must be comma separated and must not contain any spaces.
      # Only publicly routable ranges are enforceable through IpRules. 
      # IPv4 addresses or ranges contained in [10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16] not valid.
      # To allow access from azure portal add ["104.42.195.92", "40.76.54.131", "52.176.6.30", "52.169.50.45", "52.187.184.26"]
      # To allow [0.0.0.0] to Accept connections from within public Azure datacenters
      allowed_ip_range_cidrs = [
        "49.204.226.198",
        "1.2.3.4",
        "0.0.0.0",
        "104.42.195.92",
        "40.76.54.131",
        "52.176.6.30",
        "52.169.50.45",
        "52.187.184.26"
      ]
    }
  }

  # Advanced Threat Protection for Azure Cosmos DB represents an additional layer of protection
  enable_advanced_threat_protection = true

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.mysql.database.azure.com` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # Private endpoints doesn't work If using `subnet_id` to create CosmosDB inside a specified VNet.
  enable_private_endpoint               = true
  existing_private_virtual_network_name = azurerm_virtual_network.cosmos-db-vnet.name
  existing_private_subnet_name          = azurerm_subnet.cosmos-db-snet.name
  # existing_private_dns_zone     = "demo.example.com"

  # Tags
  add_tags = {
    Example = "basic_new_rg_backup"
  }
}
