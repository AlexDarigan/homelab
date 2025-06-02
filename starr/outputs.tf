output "app" {
  value = {
    ip = kubernetes_service.starr_service.spec[0].cluster_ip
    port = var.model.ports[0].internal
    node_port = var.model.ports[0].node
    api_key = random_password.api_key.result
  }

  sensitive = true

  depends_on = [ kubernetes_service.starr_service, random_password.api_key ]
}
