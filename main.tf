provider "tfe" {
  hostname = var.hostname
  token    = var.token
}

resource "tfe_organization" "dummy_org" {
  name  = "dummy-org"
  email = "admin@company.com"
}

resource "tfe_project" "test" {
  organization = tfe_organization.dummy_org.name
  name = "project"
}

resource "tfe_oauth_client" "tfe_oath" {
  name             = "my-github-oauth-client"
  organization     = tfe_organization.dummy_org.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.oauth_token
  service_provider = "github"
  organization_scoped = true
}

module "workspacer" {
  depends_on = [ tfe_project.test ] // for some reason the implicit dependency is not working

  source  = "alexbasista/workspacer/tfe"

  organization   = tfe_organization.dummy_org.name
  force_delete = true
  workspace_name = "workspacer-basic-example"
  workspace_desc = "Created by 'workspacer' Terraform module."
  workspace_tags = ["app:acme", "env:test", "cloud:aws"]
  project_name = tfe_project.test.name
  working_directory     = "create-random-stuff/"
  auto_apply            = true
  file_triggers_enabled = true
  # trigger_patterns      = ["</example/tf/directory/**/*>"]
  queue_all_runs        = true

  vcs_repo = {
    identifier         = var.vcs_repo
    branch             = "main"
    oauth_token_id     = tfe_oauth_client.tfe_oath.oauth_token_id
    ingress_submodules = false
    tags_regex         = null
  }
}