# Blog -- Infrastructure -- Codebase/GitHub

This folder contains the Terraform recipe to deploy _this_ particular
GitHub repository with the exact same settings.


## How to deploy it

### Prerequisites 

* The Azure command line tool : [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* An Azure storage account with a container named "tfstates"

### Deployment 

First, login to your Azure subscrition and initiate Terraform : 

```bash
export AZ_STORAGE_NAME="<YOUR_AZURE_STORAGE_ACCOUNT_NAME>"
export AZ_RESOURCE_GROUP="<YOUR_AZURE_STORAGE_RESOURCE_GROUP>"
az login
terraform init -backend-config storage_account_name="$AZ_STORAGE_NAME" -backend-config resource_group_name="$AZ_RESOURCE_GROUP"
```