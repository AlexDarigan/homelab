data "http" "add_download_client" {
  url    = "http://192.168.1.12:${var.application.node_port}/${var.request.route}"
  method = var.request.method
  request_headers = {
    "Content-Type": var.request.content_type,
    "X-Api-Key": var.application.api_key
  }
  request_body = local.body
}