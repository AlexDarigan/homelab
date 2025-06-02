variable "request" {
  type = object({
    route = string
    method = string
    content_type = string
    body = string
  })
}

variable "prowlarr" {
   type = object({
    ip = string
    port = number
    node_port = number
    api_key = string
  })

  sensitive = true
}

variable "app" {
  type = object({
    ip = string
    port = number
    node_port = number
    api_key = string
  })

  sensitive = true
}

locals {
  body = templatestring(var.request.body, 
    {  
      prowlarrUrl = "http://${var.prowlarr.ip}:${var.prowlarr.port}"
      baseUrl = "http://${var.app.ip}:${var.app.port}"
      apiKey = var.app.api_key
    })
}

data "http" "make_request" {
  url = "http://192.168.1.12:${var.prowlarr.node_port}/${var.request.route}"
  method = var.request.method
  request_headers = {
    "Content-Type": var.request.content_type
    "X-Api-Key": var.prowlarr.api_key
  }
  request_body = local.body
}
