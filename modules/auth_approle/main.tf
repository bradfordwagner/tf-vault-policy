resource "vault_auth_backend" "approle" {
  path = "approle"
  type = "approle"
}

resource "vault_approle_auth_backend_role" "k8s_auth_bootstrapper" {
  backend        = vault_auth_backend.approle.path
  role_name      = "k8s_auth_bootstrapper"
  token_policies = ["k8s_auth_bootstrapper"]
}
