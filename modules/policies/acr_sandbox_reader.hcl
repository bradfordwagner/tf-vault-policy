path "secret/data/azure/acr/sandbox" {
  capabilities = ["read"]
}

# required for helm acr login sequence
path "secret/data/azure/sp/infra" {
  capabilities = ["read"]
}

