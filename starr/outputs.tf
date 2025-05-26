output "app" {
  value = {
    ip = kubernetes_service.arr_service.spec[0].cluster_ip
    port = var.model.ports[0].internal
    api_key = random_password.api_key.result
  }

  sensitive = true

  depends_on = [ kubernetes_service.arr_service, random_password.api_key ]
}
