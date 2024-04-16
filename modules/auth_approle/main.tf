resource "vault_auth_backend" "approle" {
  path = "approle"
  type = "approle"
  tune {
    max_lease_ttl = "2160h" # 90 days
  }
}

resource "vault_approle_auth_backend_role" "k8s_auth_bootstrapper" {
  backend        = vault_auth_backend.approle.path
  role_name      = "k8s_auth_bootstrapper"
  token_policies = ["k8s_auth_bootstrapper"]
}

resource "vault_approle_auth_backend_role" "gh_actions" {
  backend        = vault_auth_backend.approle.path
  role_name      = "gh_terraform"
  token_policies = ["azure_sp_infra_reader"]
}

resource "vault_approle_auth_backend_role" "vault_policy_scaffolding" {
  backend        = vault_auth_backend.approle.path
  role_name      = "vault_policy_scaffolding"
  token_policies = ["admin", "azure_sp_infra_reader"]
}
