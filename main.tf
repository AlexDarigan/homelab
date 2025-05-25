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
  config = jsondecode(file("config.json"))
}


# module "install_k3s" {
#   source = "./install"
#   host = local.connection.host
#   user = local.connection.user
#   type = local.connection.type
#   agent = local.connection.agent
# }

# resource "null_resource" "create_arr_namespace" {

#   provisioner "local-exec" {
#     command = "kubectl create namespace arr-stack"
#   } 
# }

module "arr" {
  KUBECONFIG = var.KUBECONFIG
  source = "./arr"
  agent = local.connection.agent
  host = local.connection.host
  type = local.connection.type
  user = local.connection.user
  config = local.config
}

