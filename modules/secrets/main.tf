resource "vault_mount" "kv2" {
  path        = "secret"
  type        = "kv-v2"
  description = "This is an example KV Version 2 secret engine mount"
}
