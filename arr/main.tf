variable "KUBECONFIG" {
  type = string
  sensitive = true
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    http = {
      source = "hashicorp/http"
      version = "3.5.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0" # Use an appropriate version
    }
  }
  
}

provider "kubernetes" {
    config_path = var.KUBECONFIG
}

module "arrstackX" {
  source       = "./core"
  for_each     = var.config
  name         = each.value.name
  namespace    = each.value.namespace
  image        = each.value.image
  ports        = each.value.ports
  service_type = each.value.service_type
}

module "Transmission" {
  KUBECONFIG = var.KUBECONFIG
  name = "transmission"
  source = "./download"
  image = "lscr.io/linuxserver/transmission"
  port = 9090
  replicas = 1
  node_port = 30014
}

