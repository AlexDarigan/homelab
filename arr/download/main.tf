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
    namespace = var.namespace
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
        container {
          name = local.container_name
          image = var.image
          port {
            container_port = 9091 # Transmission Web UI
            name           = "web-ui"
            protocol       = "TCP"
          }
          port {
            container_port = 51413 # Transmission BitTorrent P2P (configurable in Transmission)
            name           = "bittorrent-tcp"
            protocol       = "TCP"
          }
          port {
            container_port = 51413 # Transmission BitTorrent P2P (for uTP)
            name           = "bittorrent-udp"
            protocol       = "UDP"
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


resource "kubernetes_service_v1" "transmission_webui_nodeport_service" {
  metadata {
    namespace = var.namespace
    name = "transmission-webui-nodeport-service"
    labels = {
      app = local.app_name
    }
  }
  spec {
    selector = {
      app = local.app_name
    }
    port {
      protocol    = "TCP"
      port        = 9091 # Port on the Service
      target_port = "web-ui" # Name of the port in the container spec (or 9091 if no name)
      node_port   = 30014 # !!! IMPORTANT: Choose a NodePort between 30000-32767. This is the port you'll use to access from outside.
      name        = "http-webui" # Descriptive name for the port
    }
    type = "NodePort" # Accessible from outside the cluster via node IP and NodePort
  }
}

# --- Service for Transmission BitTorrent P2P Traffic (NodePort) ---
# This exposes the BitTorrent P2P port directly on the k3s nodes.
# You will need to port-forward this NodePort on your router if k3s is behind one.
resource "kubernetes_service_v1" "transmission_bittorrent_nodeport_service" {
  metadata {
    namespace = var.namespace
    name = "transmission-bittorrent-nodeport-service"
    labels = {
      app = local.app_name
    }
  }
  spec {
    selector = {
      app = local.app_name
    }
    port {
      protocol    = "TCP"
      port        = 51413 # External port on the Service
      target_port = "bittorrent-tcp" # Port on the pod
      node_port   = 30413 # !!! IMPORTANT: Choose a NodePort between 30000-32767. This is the port you'll use.
      name        = "bittorrent-tcp"
    }
    port {
      protocol    = "UDP"
      port        = 51413 # External port on the Service
      target_port = "bittorrent-udp" # Port on the pod
      node_port   = 30414 # !!! IMPORTANT: Choose a different NodePort for UDP, or let Kubernetes assign
      name        = "bittorrent-udp"
    }
    type = "NodePort" # Exposes on a port on each node
  }
}