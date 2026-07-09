# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Pure Terraform scaffolding for a single HashiCorp Vault instance (`https://bradfordwagner.com:8200`). It only
declares Vault resources (policies, auth backends, roles, a kv-v2 mount) — there is no application code. Per the
README: "This just scaffolds structure, nothing more no implementations nothin!"

## Commands

```bash
terraform init -backend-config=backend.hcl   # required: backend config is partial, supplied via backend.hcl
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

There is no test suite or linter beyond `terraform fmt`/`validate`. State lives in Azure Storage (`azurerm`
backend, configured in `backend.hcl`); the provider `vault {}` block takes its address/token from environment
variables (`VAULT_ADDR`, `VAULT_TOKEN`), not from files in this repo.

## Architecture

- `main.tf` wires together the top-level modules. `module.policies` has no dependencies; every other module
  (`auth_approle`, `k8s_auth`, `auth_userpass`) declares `depends_on = [module.policies]` because they reference
  policy names by string — Terraform can't infer that dependency automatically since roles attach policies via
  `token_policies = ["some_policy_name"]` rather than resource references.
- `modules/policies/` defines one `vault_policy` resource per `.hcl` file in the same directory (e.g.
  `admin.hcl`, `quay_reader.hcl`). To add a policy: write a new `<name>.hcl` file with the Vault policy syntax,
  then add a matching `vault_policy` resource in `modules/policies/main.tf` that points at it via
  `file("${path.module}/<name>.hcl")`. Policy names are the cross-module contract — every other module
  references them as plain strings.
- `modules/auth_approle/` enables the `approle` auth backend and defines approle roles, each with a
  `token_policies` list drawn from `modules/policies`.
- `modules/k8s_auth/` enables a `kubernetes` auth backend per cluster. It's instantiated with
  `for_each = var.k8s_clusters` (`variables.tf` at the root: `["admin", "cicd"]`). Most roles inside are gated
  with `count = var.k8s_cluster == "cicd" ? 1 : 0`, since the `cicd` cluster runs the CI/CD workflows and needs
  role bindings for `argo`/`argo-events` service accounts; the `admin` cluster only gets the `smoketest` role.
  When adding a new k8s-auth-backed role, follow the existing pattern: bind a service account/namespace to a
  role name and a list of policies from `modules/policies`.
- `modules/auth_userpass/` just enables the `userpass` auth backend (no roles/users defined here).
- `modules/secrets/` mounts the `kv-v2` secrets engine at `secret/`. Policy paths elsewhere use the `data/`
  KV-v2 prefix convention, e.g. `secret/data/azure/sp/infra`.

## CI/CD

Two parallel pipelines exist for this repo:

- **GitHub Actions** (`.github/workflows/`): `config.yaml` at the repo root defines the Terraform workspace
  matrix (`workspaces[].name`/`.path`) consumed by both workflows via `yq`/`jq`. Both jobs authenticate to Vault
  with AppRole (`ROLE_ID`/`SECRET_ID` secrets) and run Terraform via a shared external `task` runner
  (`bradfordwagner/taskfiles`, `terraform.yml`). Push events run `tf_action=plan`; tag pushes run
  `tf_action=apply` with `target_tag=${{ github.ref_name }}`.
- **Argo Workflow** (`workflow.yaml`): an alternative/legacy CI entrypoint using a shared `flavor-terraform-template`,
  referencing the `vault_policy_scaffolding` Vault role and an Azure CSI secret (`sp-infra`) for credentials.

`config.yaml` also documents (informationally) which Vault auth/secrets this repo's own CI needs: AppRole role
`vault_policy_scaffolding` and read access to `secret/azure/sp/infra` — this is what
`modules/auth_approle`'s `vault_policy_scaffolding` role and `modules/k8s_auth`'s
`cicd_vault_policy_scaffolding` role grant.

## Conventions when adding resources

- New Vault policies: add the `.hcl` file to `modules/policies/`, wire it up in `modules/policies/main.tf`.
- New consumers of a policy (approle role, k8s auth role, etc.): reference the policy by its Vault name string
  in `token_policies`, and add `depends_on = [module.policies]` at the module level if it's a new module.
- Keep policy paths consistent with the `secret/data/...` KV-v2 convention already used by existing `.hcl` files.
