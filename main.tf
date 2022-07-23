provider "vault" {}

module "policies" {
  source = "./modules/policies"
}

module "approle" {
  depends_on = [module.policies]
  source     = "./modules/auth_approle"
}

module "k8s_clusters" {
  depends_on  = [module.policies]
  for_each    = var.k8s_clusters
  source      = "./modules/k8s_auth"
  k8s_cluster = each.key
}

module "userpass" {
  depends_on = [module.policies]
  source     = "./modules/auth_userpass"
}

module "secrets" {
  source     = "./modules/secrets"
}
