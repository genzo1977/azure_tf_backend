# made changes
provider "azurerm" {
  features {}

  subscription_id = "<SUBSCRIPTION_ID>"
}

resource "random_pet" "prefix" {
  length = 1 # Generates a single-word pet name (e.g., "maggot").
}

# Generate a random string (lowercase alphanumeric)
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  location = "uksouth"
  name     = "${random_pet.prefix.id}-rg"
}

# Create a storage account with a unique name
resource "azurerm_storage_account" "storage" {
  name                     = "${random_pet.prefix.id}${random_string.suffix.id}tf" # Shortened suffix.
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a storage container for the state file
resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Resource group for storing the Terraform state
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

# Storage account name for Terraform state files
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

# Storage container for the state file
output "container_name" {
  value = azurerm_storage_container.container.name
}

# Storage account access key
output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}
