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

