resource "vault_policy" "k8s_auth_bootstrapper" {
  name   = "k8s_auth_bootstrapper"
  policy = file("${path.module}/k8s_auth.hcl")
}

resource "vault_policy" "admin" {
  name = "admin"
  policy = file("${path.module}/admin.hcl")
}

resource "vault_policy" "quay_reader" {
  name = "quay_reader"
  policy = file("${path.module}/quay_reader.hcl")
}

resource "vault_policy" "bradford_argo_events_reader" {
  name = "bradford_argo_events_reader"
  policy = file("${path.module}/bradford_argo_events_reader.hcl")
}

resource "vault_policy" "go_releaser" {
  name = "go_releaser_reader"
  policy = file("${path.module}/go_releaser_reader.hcl")
}

resource "vault_policy" "azure_sp_infra_reader" {
  name = "azure_sp_infra_reader"
  policy = file("${path.module}/azure_sp_infra_reader.hcl")
}

resource "vault_policy" "acr_sandbox_reader" {
  name = "acr_sandbox_reader"
  policy = file("${path.module}/acr_sandbox_reader.hcl")
}

