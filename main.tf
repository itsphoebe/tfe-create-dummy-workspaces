provider "tfe" {
  hostname = var.hostname
  token    = var.token
}

resource "tfe_organization" "dummy_org" {
  count = var.org_count
  name  = "dummy-org-${count.index + 1}"
  email = "admin@company.com"
}

locals {
  project_map ={
    for org in tfe_organization.dummy_org : org.name => {
      for i in range(var.projects_per_org) : "project-${i + 1}" => {
        organization = org.name
        workspace_index_counter = i + 1
      }
    }
  }

  flat_project_map = flatten([ for org_name, proj_map in local.project_map: [
    for proj_name, proj_value in proj_map: { 
      workspace_index_counter = proj_value.workspace_index_counter,
      project_name = proj_name, 
      organization = org_name 
    }]
  ])
}

output "project_names" {
  value = local.flat_project_map
}

resource "tfe_project" "test" {
  for_each = { for idx, proj in local.flat_project_map: "${proj.project_name}-${proj.organization}" => proj}

  organization = each.value.organization
  name = each.value.project_name
}

resource "tfe_oauth_client" "tfe_oath" {
  for_each = { for org in tfe_organization.dummy_org : org.name => org }
  name             = "my-github-oauth-client"
  organization     = each.key
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.oauth_token
  service_provider = "github"
  organization_scoped = true
}

module "workspacer" {
  depends_on = [ tfe_project.test ]

  for_each = { for idx, proj in local.flat_project_map: "${proj.project_name}-${proj.organization}" => proj}

  source  = "alexbasista/workspacer/tfe"

  organization   = each.value.organization
  force_delete = true
  workspace_name = "dummy-workspace-${each.value.workspace_index_counter}"
  workspace_desc = "Created by 'workspacer' Terraform module."
  workspace_tags = ["app:acme", "env:test", "cloud:aws"]
  project_name = each.value.project_name
  working_directory     = "create-random-stuff/"
  auto_apply            = true
  file_triggers_enabled = true
  # trigger_patterns      = ["</example/tf/directory/**/*>"]
  queue_all_runs        = true

  vcs_repo = {
    identifier         = var.vcs_repo
    branch             = "main"
    oauth_token_id     = tfe_oauth_client.tfe_oath[each.value.organization].oauth_token_id
    ingress_submodules = false
    tags_regex         = null
  }
}