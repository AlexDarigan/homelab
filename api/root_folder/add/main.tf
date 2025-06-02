variable "app" {
  type = object({
    node_port = number
    api_key = string
  })

  sensitive = true
}

variable "request" {
  type = object({
    route = string
    method = string
    content_type = string
    body = string
  })
}

data "http" "make_request" {
  url = "http://192.168.1.12:${var.app.node_port}/${var.request.route}"
  method = var.request.method
  request_headers = {
    "Content-Type": var.request.content_type,
    "X-Api-Key": var.app.api_key
  }  
  request_body = var.request.body
}
