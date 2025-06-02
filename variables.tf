variable "RASPI_SSH_CONFIG" {
  type = string
  sensitive = true
}

variable "KUBECONFIG" {
  type = string
  sensitive = true
}

locals {
  apps = {
    for f in fileset("./starr/apps/", "*.yaml"):
    trimsuffix(f, ".yaml") => yamldecode(file("./starr/apps/${f}"))
  }

  add_prowlarr_application_requests = {
    for f in fileset("./api/application/add/", "*.yaml"):
    trimsuffix(f, ".yaml") => yamldecode(file("./api/application/add/${f}"))
  }

  set_root_folder_requests = {
    for f in fileset("./api/root_folder/add/", "*.yaml"):
    trimsuffix(f, ".yaml") => yamldecode(file("./api/root_folder/add/${f}"))
  }
}