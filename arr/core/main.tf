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
        namespace = var.namespace
        labels = {
          app = local.app_name
        }
      }
      spec {
        restart_policy = var.restart_policy
        host_network = var.host_network
        dns_policy = var.dns_policy
        dns_config { 
          nameservers = var.nameservers
        }

        container {
          name = local.container_name
          image = var.image
          
          port {
            container_port = var.port
          }
          volume_mount {
            name = local.config.name
            mount_path = local.config.mount_path
          }
          volume_mount {
            name = local.drive.name
            mount_path = local.drive.mount_path
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
          name = local.drive.name
          host_path {
            path = local.drive.host_path
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
      target_port = var.port
      port = var.port
    }
    type = var.service_type
  }
}