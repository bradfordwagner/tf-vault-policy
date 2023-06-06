path "secret/data/azure/acr/prod" {
  capabilities = ["read"]
}

# required for helm acr login sequence
path "secret/data/azure/sp/infra" {
  capabilities = ["read"]
}

