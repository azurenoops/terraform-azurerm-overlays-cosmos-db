# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Azurerm provider configuration
provider "azurerm" {
  environment = var.environment
  features {}
}