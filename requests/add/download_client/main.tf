resource "null_resource" "name" {
  
  provisioner "local-exec" {
    command = "echo '${local.body}' >> sample.json"
  }

  triggers = {
    run_always = timestamp()
  }
}

data "http" "add_download_client" {
  url    = "http://192.168.1.12:${var.application.node_port}/${var.request.route}"
  method = var.request.method
  request_headers = {
    "Content-Type": var.request.content_type,
  }
  request_body = local.body
}