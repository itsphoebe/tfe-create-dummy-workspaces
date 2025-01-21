# tfe-create-dummy-workspaces

Creates dummy org, project, workspaces for TFE with variable #s to create looots quickly. 

VCS for the workspace will point to /create-random-stuff which creates null resources and outputs a random string. 

Creates # of orgs based on var.org_count  - defaults to 2
Creates # of projects per org based on var.org_count - defaults to 2
Creates # of workspaces per project based on var.workspaces_per_project - defaults to 2

Built off: [Workspacer Module](https://github.com/alexbasista/terraform-tfe-workspacer/tree/main)

# Usage
```
hostname = "<tfe-endpoint>"
token = "<tfe-token-here>"
oauth_token = "<github-token>"
vcs_repo = "<github-repo>"
```

#### Notes on flattening
Create a map to figure out how many projects we need per org 
`local.workspace_map`
```
workspace_names = {
  dummy-org-1 = {
    project-1 = {
      workspace-1 = {
        organization = "dummy-org-1"
        project      = "project-1"
      }
      workspace-2 = {
        organization = "dummy-org-1"
        project      = "project-1"
      }
    }
    project-2 = {
      workspace-1 = {
        organization = "dummy-org-1"
        project      = "project-2"
      }
      workspace-2 = {
        organization = "dummy-org-1"
        project      = "project-2"
      }
    }
  }
  dummy-org-2 = {
    project-1 = {
      workspace-1 = {
        organization = "dummy-org-2"
        project      = "project-1"
      }
      workspace-2 = {
        organization = "dummy-org-2"
        project      = "project-1"
      }
    }
    project-2 = {
      workspace-1 = {
        organization = "dummy-org-2"
        project      = "project-2"
      }
      workspace-2 = {
        organization = "dummy-org-2"
        project      = "project-2"
      }
    }
  }
}
```

then use flatten in order to create a new with keys per group
```
workspace_names = [
  {
    organization   = "dummy-org-1"
    project        = "project-1"
    workspace_name = "workspace-1"
  },
  {
    organization   = "dummy-org-1"
    project        = "project-1"
    workspace_name = "workspace-2"
  },
  {
    organization   = "dummy-org-1"
    project        = "project-2"
    workspace_name = "workspace-1"
  },
  {
    organization   = "dummy-org-1"
    project        = "project-2"
    workspace_name = "workspace-2"
  },
  {
    organization   = "dummy-org-2"
    project        = "project-1"
    workspace_name = "workspace-1"
  },
  {
    organization   = "dummy-org-2"
    project        = "project-1"
    workspace_name = "workspace-2"
  },
  {
    organization   = "dummy-org-2"
    project        = "project-2"
    workspace_name = "workspace-1"
  },
  {
    organization   = "dummy-org-2"
    project        = "project-2"
    workspace_name = "workspace-2"
  },
]
```