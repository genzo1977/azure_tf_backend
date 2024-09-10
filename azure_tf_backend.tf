provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  location = "uksouth"
  name     = "${random_pet.prefix.id}-rg"
}

resource "random_pet" "prefix" {
  prefix = "intech"
  length = 1
}

# Create a storage account for Terraform state files
resource "azurerm_storage_account" "storage" {
  name                     = "${random_pet.prefix.id}-tfstate"
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

# Create the storage account access key output
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "container_name" {
  value = azurerm_storage_container.container.name
}

output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}