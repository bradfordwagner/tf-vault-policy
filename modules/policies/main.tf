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

