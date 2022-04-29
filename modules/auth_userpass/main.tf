## naughty passwordd configuration
resource "vault_auth_backend" "userpass" {
  path = "userpass"
  type = "userpass"
}

