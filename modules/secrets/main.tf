resource "vault_mount" "kv2" {
  path        = "secret"
  type        = "kv-v2"
  description = "static artisinally crafted secrets"
}
