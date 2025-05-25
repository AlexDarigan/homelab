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
          dynamic "port" {
            for_each = var.ports
            content {
              container_port = port.value.internal
            }
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


