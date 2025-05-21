terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

provider "kubernetes" {
    config_path = var.KUBECONFIG
}


resource "kubernetes_deployment" "arr_deployment" {
  metadata {
    name = local.deployment_name
    labels = {
      app = local.app_name
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = local.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = local.app_name
        }
      }
      spec {
        restart_policy = var.restart_policy

        dns_policy = var.dns_policy
        dns_config { 
          nameservers = var.nameservers
        }

        container {
          name = local.container_name
          image = var.container.image
          
          port {
            container_port = var.ports.internal
          }
          volume_mount {
            name = local.config.name
            mount_path = local.config.mount_path
          }
          volume_mount {
            name = local.library.name
            mount_path = local.library.mount_path
          }
          env {
            name  = "PUID"
            value = var.puid
          }
          env {
            name  = "PGID"
            value = var.pgid
          }
          env {
            name = "UMASK"
            value = var.umask
          }
          env {
            name = "TZ"
            value = var.tz
          }
        }
        volume {
          name = local.library.name
          host_path {
            path = local.library.host_path
          }
        }
        volume {
          name = local.config.name
          host_path {
            path = local.config.host_path
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "arr_service" {
  metadata {
    name = local.service_name
  }
  spec {
    selector = {
      app = local.app_name
    }
    
    port {
      port = var.ports.container
      target_port = var.ports.service
      node_port = var.ports.node_port
    }
    type = var.service_type
  }
}