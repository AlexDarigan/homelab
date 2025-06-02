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
    random = {
      source = "hashicorp/random"
      version = "~> 3.7.2"
    }
    time = {
      source = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "kubernetes" {
    config_path = var.KUBECONFIG
}