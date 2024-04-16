resource "vault_auth_backend" "approle" {
  path = "approle"
  type = "approle"
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
