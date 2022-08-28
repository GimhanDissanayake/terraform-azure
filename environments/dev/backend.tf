terraform {
  backend "azurerm" {
    storage_account_name = "<STORAGE_NAME" # env specific
    container_name       = "tfstate" # container name inside Blob
    key                  = "prod.terraform.tfstate" # tfstate file name
    use_azuread_auth     = true
    subscription_id      = "SUBSCRIPTION_ID" # env specific
    tenant_id            = "<TENANT_ID>"
  }
}
