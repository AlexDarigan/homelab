output "baseUrl" {
  value = kubernetes_service.arr_service.spec[0].cluster_ip
}