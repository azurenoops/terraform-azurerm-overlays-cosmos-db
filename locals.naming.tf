locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name = element(coalescelist(data.azurerm_resource_group.rg.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rg.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  cosmosdb_name       = coalesce(var.custom_cosmosdb_name, data.azurenoopsutils_resource_name.cosmosdb.result)
}
