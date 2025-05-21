terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

locals {
  connection = jsondecode(file(var.RASPI_SSH_CONFIG))
}


module "install_k3s" {
  source = "./install"
  host = local.connection.host
  user = local.connection.user
  type = local.connection.type
  agent = local.connection.agent
}

module "arr" {
  KUBECONFIG = var.KUBECONFIG
  source = "./arr"
}
