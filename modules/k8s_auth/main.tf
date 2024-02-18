resource "vault_auth_backend" "current" {
  path = "kubernetes/${var.k8s_cluster}"
  type = "kubernetes"
  tune {
    max_lease_ttl = "120s"
  }
}

# resource "vault_mount" "kubernetes_mount" {
#   path        = "${var.k8s_cluster}"
#   # path        = "kubernetes/${var.k8s_cluster}"
#   type        = "kubernetes"
#   description = "Kubernetes role for Vault"
#   # options = {
#     # kubernetes_host         = "https://kubernetes.default.svc"
#     # kubernetes_ca_cert      = "<kubernetes_ca_certificate>"
#     # kubernetes_token_reviewer_jwt = "some_jwt_token"
#     # kubernetes_token_reviewer_role = "role_name"
#     # kubernetes_jwt_auth_path = "kubernetes/auth"
#     # kubernetes_issuer       = "kubernetes.io/token"
#     # kubernetes_pem_keys     = "<pem_keys>"
#     # kubernetes_service_account = "default"
#     # kubernetes_service_account_namespace = "default"
#     # kubernetes_service_account_jwt = "<service_account_jwt>"
#     # kubernetes_pod_template_file = "<pod_template_file>"
#     # kubernetes_ttl          = "1h"
#     # kubernetes_max_ttl      = "24h"
#     # token_policies          = ["default"]
#     # token_period            = "1h"
#   # }
# }

resource "vault_kubernetes_auth_backend_role" "smoketest" {
  backend                          = vault_auth_backend.current.path
  role_name                        = "smoketest"
  bound_service_account_names      = ["smoketest"]
  bound_service_account_namespaces = ["vault"]
  token_ttl                        = 60
  token_policies                   = ["admin"]
  alias_name_source                = "serviceaccount_name"
}

# used for this repository setting up vault policy
resource "vault_kubernetes_auth_backend_role" "cicd_vault_policy_scaffolding" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "vault_policy_scaffolding"
  token_policies                   = ["admin", "azure_sp_infra_reader"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "cicd_quay" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "quay_reader"
  token_policies                   = ["quay_reader"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "cicd_bradford_argo_events_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo-events"]
  role_name                        = "bradford_argo_events_reader"
  token_policies                   = ["bradford_argo_events_reader"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "go_releaser" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "go_releaser_reader"
  token_policies                   = ["go_releaser_reader"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "cicd_azure_sp_infra_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "azure_sp_infra_reader"
  token_policies                   = ["azure_sp_infra_reader"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "cicd_azure_acr_sandbox_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "acr_sandbox_reader"
  token_policies                   = ["acr_sandbox_reader"]
  alias_name_source                = "serviceaccount_name"
}

resource "vault_kubernetes_auth_backend_role" "cicd_azure_acr_prod_reader" {
  count                            = var.k8s_cluster == "cicd" ? 1 : 0
  backend                          = vault_auth_backend.current.path
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["argo"]
  role_name                        = "acr_prod_reader"
  token_policies                   = ["acr_prod_reader"]
  alias_name_source                = "serviceaccount_name"
}

