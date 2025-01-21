# tfe-create-dummy-workspaces

Creates dummy org, project, workspaces for TFE

Creates # of orgs based on var.org_count  - defaults to 2
Creates # of projects per org based on var.org_count - defaults to 2


#### Notes on flattening
Create a map to figure out how many projects we need per org 
`local.project_map`
```
project_names = {
  dummy-org-0 = {
    project-dummy-org-0-0 = {
      organization = "dummy-org-0"
    }
    project-dummy-org-0-1 = {
      organization = "dummy-org-0"
    }
  }
  dummy-org-1 = {
    project-dummy-org-1-0 = {
      organization = "dummy-org-1"
    }
    project-dummy-org-1-1 = {
      organization = "dummy-org-1"
    }
  }
}
```

then use flatten in order to create a new with keys per group
before flatten:
```
project_names = [
  [
    {
      organization = "dummy-org-1"
      project_name = "project-1"
    },
    {
      organization = "dummy-org-1"
      project_name = "project-2"
    },
  ],
  [
    {
      organization = "dummy-org-2"
      project_name = "project-1"
    },
    {
      organization = "dummy-org-2"
      project_name = "project-2"
    },
  ],
]
```

after flatten:
```
project_names = [
  {
    organization = "dummy-org-1"
    project_name = "project-1"
  },
  {
    organization = "dummy-org-1"
    project_name = "project-2"
  },
  {
    organization = "dummy-org-2"
    project_name = "project-1"
  },
  {
    organization = "dummy-org-2"
    project_name = "project-2"
  },
]
```