resource "azure_storage_account" "blog" {
  name                     = "an0rak-blog"
  resource_group_name      = var.az_resource_group
  location                 = var.az_location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = {
    creator = "terraform"
    purpose = "blog"
  }
}