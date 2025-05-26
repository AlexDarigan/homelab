variable "request" {
  type = object({
    route = string
    method = string
    content_type = string
    body = any
  })
}

variable "prowlarr" {
  type = object({
    ip = string
    port = number
    api_key = string
  })

  sensitive = true
}

variable "application" {
  type = object({
    ip = string
    port = number
    api_key = string
  })
}

locals {
  body = replace(
    replace(
      replace(
        jsonencode(var.request.body), 
        "_source_url", 
        "http://${var.prowlarr.ip}:${var.prowlarr.port}"
        ), 
        "_target_url", 
        "http://${var.application.ip}:${var.application.port}"
        ),
        "_api_value", 
        var.application.api_key
  )
}