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

resource "kubernetes_deployment" "filebrowser" {
  metadata {
    name = "filebrowser-deployment"
    labels = {
      app = "filebrowser"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "filebrowser"
      }
    }
    template {
      metadata {
        labels = {
          app = "filebrowser"
        }
      }
      spec {
        container {
          name  = "filebrowser"
          image = "filebrowser/filebrowser:latest"
          port {
            container_port = 8001
          }
          volume_mount {
            name      = "data"
            mount_path = "/data"
          }
          volume_mount {
            name      = "config"
            mount_path = "/config"
          }
        }
        volume {
          name = "data"
          host_path {
            path = "/data/filebrowser" # Replace with your desired path on the Pi
            type = "DirectoryOrCreate"
          }
        }
        volume {
          name = "config"
          host_path {
            path = "/data/config" # Replace with your desired path on the Pi
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "filebrowser" {
  metadata {
    name = "filebrowser-service"
  }
  spec {
    selector = {
      app = "filebrowser"
    }
    port {
      protocol    = "TCP"
      port        = 8001
      target_port = 8001
    }
    type = "LoadBalancer"
  }
}
