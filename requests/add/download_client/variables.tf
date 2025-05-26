variable "request" {
  type = object({
    route = string
    method = string
    content_type = string
    body = any
  })
}

variable "transmission" {
  type = object({
    ip = string
    port = number
    node_port = number
    api_key = string
  })

    // We don't acutally use an apiKey but always good to make sure
    sensitive = true
}

variable "application" {
  type = object({
    ip = string
    port = number
    node_port = number
    api_key = string
  })
}

locals {
  body = replace(
        jsonencode(var.request.body), 
        "_host_url", 
        "${var.transmission.ip}"
        )
}

#  "_port", 
#         "\\${var.transmission.port}"