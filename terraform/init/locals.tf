locals {
  project_name = "playground-init-k8s"
  project_name_no_dash = replace(local.project_name, "-", "")
  region       = "westeurope"
}
