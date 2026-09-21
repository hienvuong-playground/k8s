resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project_name}"
  location = local.region
  tags = {
    CREATED_BY = "Hien Vuong"
  }
}

resource "azurerm_storage_account" "main" {
  name                      = "st${local.project_name_no_dash}"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = local.region
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = false
}

resource "azurerm_storage_container" "main" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "main" {
  location            = azurerm_resource_group.main.location
  name                = "id-${local.project_name}"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_federated_identity_credential" "k8s" {
  name                      = "k8s"
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  user_assigned_identity_id = azurerm_user_assigned_identity.main.id
  subject                   = "repo:hienvuong-playground@325346053/k8s@1378931138:ref:refs/heads/main"
}

# resource "azurerm_role_assignment" "owner" {
#   principal_id         = azurerm_user_assigned_identity.main.principal_id
#   role_definition_name = "Owner"
#   scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
# }

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  principal_id         = azurerm_user_assigned_identity.main.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.main.id
}

resource "github_actions_variable" "client_id" {
  variable_name = "AZURE_CLIENT_ID"
  repository    = "k8s"
  value         = "170b3eb4-1652-46c9-9a73-d084603c7fbf"
}

resource "github_actions_variable" "tenant_id" {
  variable_name = "AZURE_TENANT_ID"
  repository    = "k8s"
  value         = "5f431148-1e24-4600-af0b-cdaeeffa6045"
}

resource "github_actions_variable" "subscription_id" {
  variable_name = "AZURE_SUBSCRIPTION_ID"
  repository    = "k8s"
  value         = "a5f932d9-c773-4a18-bba4-d37f82f974a3"
}
