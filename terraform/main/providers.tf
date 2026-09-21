terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.4.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "~> 3.2.1"
    # }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "~> 3.3.0"
    # }
  }

  backend "azurerm" {
    use_oidc             = true # Has to be enable, otherwise it uses the credentials from az login when running github actions
    use_azuread_auth     = true
    tenant_id            = "05d0fb8b-e674-421f-81e0-eb7737ff8128"
    client_id            = "80c9c7ba-bc37-4fc6-b21e-2fb660764ae6"
    storage_account_name = "stplaygroundinitk8s"
    key                  = "terraform.tfstate"
    container_name       = "tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "github" {
  owner = "hienvuong-playground"

  app_auth {
    id              = "4998541"
    installation_id = "162938087"
    pem_file        = var.github_app_pem
  }
}

# provider "kubernetes" {
#   host                   = azurerm_kubernetes_cluster.main.kube_config[0].host
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "kubelogin"
#     args = [
#       "get-token",
#       "--environment",
#       "AzurePublicCloud",
#       "--server-id",
#       "6dae42f8-4368-4678-94ff-3960e28e3630", # https://azure.github.io/kubelogin/concepts/aks.html
#       "--client-id",
#       data.azurerm_client_config.current.client_id,
#       "--tenant-id",
#       data.azurerm_client_config.current.tenant_id,
#       "--login",
#       "azurecli"
#     ]
#   }
# }

# provider "helm" {
#   kubernetes = {
#     host                   = azurerm_kubernetes_cluster.main.kube_config[0].host
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)

#     exec = {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "kubelogin"
#       args = [
#         "get-token",
#         "--environment",
#         "AzurePublicCloud",
#         "--server-id",
#         "6dae42f8-4368-4678-94ff-3960e28e3630", # https://azure.github.io/kubelogin/concepts/aks.html
#         "--client-id",
#         data.azurerm_client_config.current.client_id,
#         "--tenant-id",
#         data.azurerm_client_config.current.tenant_id,
#         "--login",
#         "azurecli"
#       ]
#     }
#   }
# }

data "azurerm_client_config" "current" {}