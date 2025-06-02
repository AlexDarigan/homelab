resource "kubernetes_service" "starr_service" {
  metadata {
    namespace = var.model.namespace
    name = var.model.name
  }
  spec {
    selector = {
      app = var.model.name
    }
    
    dynamic "port" {
      for_each = var.model.ports
      content {
        name = port.value.name
        protocol = port.value.protocol
        target_port = port.value.internal
        port = port.value.external
        node_port = port.value.node
      }
    }
    type = var.model.service_type
  }

  wait_for_load_balancer = true
}