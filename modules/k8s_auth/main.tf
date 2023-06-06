resource "vault_auth_backend" "current" {
  path = "kubernetes/${var.k8s_cluster}"
  type = "kubernetes"
  tune {
    max_lease_ttl = "120s"
  }
}

resource "vault_kubernetes_auth_backend_role" "smoketest" {
  backend                          = vault_auth_backend.current.path
  role_name                        = "smoketest"
  bound_service_account_names      = ["smoketest"]
  bound_service_account_namespaces = ["vault"]
  token_ttl                        = 60
  token_policies                   = ["admin"]
}

# used for this repository setting up vault policy
resource "vault_kubernetes_auth_backend_role" "cicd_vault_policy_scaffolding" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "vault_policy_scaffolding"
  token_policies                   = ["admin", "azure_sp_infra_reader"]
}

resource "vault_kubernetes_auth_backend_role" "cicd_quay" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "quay_reader"
  token_policies                   = ["quay_reader"]
}

resource "vault_kubernetes_auth_backend_role" "cicd_bradford_argo_events_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo-events"]
  role_name                        = "bradford_argo_events_reader"
  token_policies                   = ["bradford_argo_events_reader"]
}

resource "vault_kubernetes_auth_backend_role" "go_releaser" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "go_releaser_reader"
  token_policies                   = ["go_releaser_reader"]
}

resource "vault_kubernetes_auth_backend_role" "cicd_azure_sp_infra_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "azure_sp_infra_reader"
  token_policies                   = ["azure_sp_infra_reader"]
}

resource "vault_kubernetes_auth_backend_role" "cicd_azure_acr_sandbox_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "acr_sandbox_reader"
  token_policies                   = ["acr_sandbox_reader"]
}

resource "vault_kubernetes_auth_backend_role" "cicd_azure_acr_prod_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "acr_prod_reader"
  token_policies                   = ["acr_prod_reader"]
}

