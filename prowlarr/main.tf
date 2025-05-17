terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

provider "kubernetes" {
    config_path = var.kubeconfig
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = var.deployment_name
    labels = {
      app = var.deployment_name
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.deployment_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.deployment_name
        }
      }
      spec {
        container {
          name = var.container.name
          image = var.container.image
          port {
            container_port = var.ports.container
          }
          volume_mount {
            name = var.volumes.config.name
            mount_path = var.volumes.config.mount_path
          }
          env {
            name  = var.env.puid.name
            value = var.env.puid.value
          }
          env {
            name  = var.env.pgid.name
            value = var.env.pgid.value
          }
          env{
            name = var.env.tz.name
            value = var.env.tz.value
          }
        }
        volume {
          name = "config"
          empty_dir {
             size_limit = "1Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = var.service_name
  }
  spec {
    selector = {
      app = var.deployment_name
    }
    port {
      port = var.ports.service
    }
    type = var.service_type
  }
}