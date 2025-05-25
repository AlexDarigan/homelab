resource "kubernetes_service" "arr_service" {
  metadata {
    namespace = var.namespace
    name = local.service_name
  }
  spec {
    selector = {
      app = local.app_name
    }
    
    dynamic "port" {
      for_each = var.ports
      content {
        target_port = port.value.internal
        port = port.value.external
        node_port = port.value.node
      }
    }
    type = var.service_type
  }
}
