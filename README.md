To create a remote backend for Terraform in Azure, you can use Azure Storage to store the Terraform state files and Azure Cosmos DB or Azure Blob's native locking mechanism to manage state locking. Here's how to configure it using Azure Storage.

### Steps to Initialize and Apply:
1. Run `terraform init` to initialize the backend.
2. Run `terraform apply` to apply the infrastructure and store the state remotely.
3. Update Terraform provider block in your architecture directory with the below
```
  backend "azurerm" {
    resource_group_name  = "your-resource-group"
    storage_account_name = "yourstorageaccount"
    container_name       = "your-container"
    key                  = "terraform.tfstate"
  }
```
