resource "random_password" "api_key" {
  length = 20
  special = false
}

resource "kubernetes_deployment" "arr_deployment" {
  
  depends_on = [ random_password.api_key ]

  metadata {
    namespace = var.model.namespace
    name = local.deployment_name
    labels = {
      app = local.app_name
    }
  }

  spec {
    replicas = var.model.replicas
    
    selector {
      match_labels = {
        app = local.app_name
      }
    }

    template {
      metadata {
        namespace = var.model.namespace
        labels = {
          app = local.app_name
        }
      }

      spec {
        container {
          name = local.container_name
          image = var.model.image

          dynamic "port" {
            for_each = var.model.ports
            content {
              protocol = port.value.protocol
              container_port = port.value.internal
            }
          }

          // Setting Volume Mounts
          dynamic "volume_mount" {
            for_each = var.model.volumes
            content {
              name = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
            }
          }
        
          // Setting Environment Variables
          dynamic "env" {
            for_each = var.env
            content {
              name = env.value.name
              value = env.value.value
            }
          }

          env {
            name = "${upper(var.model.name)}__AUTH__APIKEY"
            value = random_password.api_key.result
          }
        }

        // Hosting Volumes
        dynamic "volume" {
          for_each = var.model.volumes
          content {
            name = volume.value.name
            host_path {
              path = volume.value.host_path
            }
          }
        }
      }
    }
  }  
}


