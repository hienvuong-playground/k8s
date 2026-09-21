resource "azurerm_role_assignment" "current_aks_rbac_cluster_admin" {
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = local.cluster_id
}
