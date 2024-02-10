# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environment"
  type        = string
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
}

#######################
# RG Configuration   ##
#######################

variable "create_cosmos_db_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false."
  type        = bool
  default     = false
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

#####################################
# Private Endpoint Configuration   ##
#####################################

variable "enable_private_endpoint" {
  description = "Manages a Private Endpoint to Azure Container Registry. Default is false."
  default     = false
}

variable "existing_private_dns_zone" {
  description = "Name of the existing private DNS zone"
  default     = null
}

variable "private_subnet_address_prefix" {
  description = "The name of the subnet for private endpoints"
  default     = null
}

variable "create_private_endpoint_subnet" {
  description = "Controls if the subnet should be created. If set to false, the subnet name must be provided. Default is false."
  type        = bool
  default     = false
}

variable "existing_private_subnet_name" {
  description = "Name of the existing subnet for the private endpoint"
  default     = null
}

variable "existing_private_virtual_network_name" {
  description = "Name of the existing virtual network for the private endpoint"
  default     = null
}

variable "resource_types" {
  description = "The Azure Cosmos DB API type that you want to map for the private endpoint. This defaults to only one choice for the APIs for `SQL`, `MongoDB`, and `Cassandra`. Defaults to `Sql`. For the APIs for Gremlin and Table, you can also choose `NoSQL` because these APIs are interoperable with the API for `NoSQL`."
  type        = list(string)
  default     = ["Sql"]
}
