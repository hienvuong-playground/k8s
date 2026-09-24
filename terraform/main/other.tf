data "azurerm_user_assigned_identity" "keda" {
  name                = "id-${local.project_name}-keda"
  resource_group_name = "rg-${local.project_name}"
}

resource "kubernetes_annotations" "keda_operator_sa" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = "keda-operator"
    namespace = "kube-system"
  }
  annotations = {
    "azure.workload.identity/client-id" = data.azurerm_user_assigned_identity.keda.client_id
  }
}
