# Blog -- Infrastructure -- Codebase/GitHub

This folder contains the Terraform recipe to deploy _this_ particular
GitHub repository with the exact same settings.

_Note that if you want to use GitHub as your remote code repository, 
GitHub actions workflows are available in this project and you'll need
the following secrets in your GH repo, and an Azure AD ServicePrincipal with Contributor
role to your Subscription :_
* `AZ_STORAGE` : the name of your Azure storage account which holds your tfstates
* `AZ_RGROUP` : the name of your Azure resource group which holds the Azure storage
* `AZ_CLIENT_ID` : the client id of the Azure AD ServicePrincipal which will be used by Terraform to access your Storage
* `AZ_CLIENT_SECRET`: the secret of the Azure AD ServicePrincipal
* `AZ_SUBSCRIPTION_ID`: the id of the Azure subscription which will hold the Storage account
* `AZ_TENANT_ID` : the tenant id which depends your subscription. 
* `GH_PAT` : A GitHub personal access token with the permissions `repo` & `org:read`.

## How to deploy it

### Prerequisites 

* The Azure command line tool, see [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* An Azure storage account with a container named `tfstates`
* A GitHub Personal Access Token to your account, see [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

### Deployment 

First, login to your Azure subscrition and initiate Terraform : 

```bash
export AZ_STORAGE_NAME="<YOUR_AZURE_STORAGE_ACCOUNT_NAME>"
export AZ_RESOURCE_GROUP="<YOUR_AZURE_STORAGE_RESOURCE_GROUP>"
az login
terraform init -backend-config storage_account_name="$AZ_STORAGE_NAME" -backend-config resource_group_name="$AZ_RESOURCE_GROUP"
```

Then launch the plan :

```bash
export GITHUB_PAT="<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN>"
terraform plan -var gh_pat=$GITHUB_PAT -out codebase.tfplan
```

Finally, review the changes and if it's ok for you, run : 

```bash
terraform apply -out codebase.tfplan
```

## Push a fork of this repo to your GitHub repo

Now that you've deployed your GitHub repository, you need to push the code
to it.

First retrieve the git clone url from the Terraform's output, then do : 

```bash
git remote add origin <YOUR_GH_CLONE_URL>
```

And edit, in your newly created repository's settings, the branch protection to
allow force push on `main`, then do :

```bash
git push --force origin main
```

And _voila_, don't forget to put disable again force push (or rerun the Terraform
recipe).