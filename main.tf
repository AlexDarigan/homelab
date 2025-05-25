terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

locals {
  connection = jsondecode(file(var.RASPI_SSH_CONFIG))
  config = jsondecode(file("config.json"))
}

provider "kubernetes" {
    config_path = var.KUBECONFIG
}

# module "install_k3s" {
#   source = "./install"
#   host = local.connection.host
#   user = local.connection.user
#   type = local.connection.type
#   agent = local.connection.agent
# }

module "arr" {
  source = "./arr"
  for_each = local.config.apps
  model = each.value
  env = local.config.env
}
