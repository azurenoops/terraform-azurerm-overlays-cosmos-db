# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  default_failover_locations = {
    default = {
      location       = local.location
      zone_redundant = var.enable_zone_redundancy
    }
  }
}
