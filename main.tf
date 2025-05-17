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

resource "null_resource" "install_k3s" {
  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -s -- --disable traefik --disable local-storage --write-kubeconfig-mode 644"
    ]

    connection {
      type = local.connection.type 
      host = local.connection.host
      user = local.connection.user
      agent = local.connection.agent
    }
  }
}

module "filebrowser" {
  source = "./filebrowser"
  kubeconfig = var.KUBECONFIG
}

module "nginx" {
  source = "./ngnix"
  # kubeconfig = var.kubeconfig
  kubeconfig = var.KUBECONFIG
  app_name = "simple-website"
  deployment_name = "simple-website-deployment"
  service_name = "simple-website-service"
  node_port = 30001
  greeting = "A Website"
}

module "nginx2" {
  source = "./ngnix"
  kubeconfig = var.KUBECONFIG
  app_name = "simple-website-b"
  deployment_name = "simple-website-deployment-b"
  service_name = "simple-website-service-b"
  node_port = 30002
  greeting = "B Website"
}

module "prowlarr" {
  source = "./prowlarr"
  deployment_name = "prowlarr"
  service_name = "prowlarr-service"
  container = {
    name = "prowlarr"
    image = "lscr.io/linuxserver/prowlarr:latest"
  }
  ports = {
    container = 9696
    service = 9696
  }
  replicas = 1
  service_type = "LoadBalancer"
  kubeconfig = var.KUBECONFIG
  env = var.env
  volumes = {
    config = {
      name = "config"
      mount_path = "/config" # Check where this is being stored
    }
  }
}

