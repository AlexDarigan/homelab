variable "app" {
  type = object({
    node_port = number
    api_key = string
    folder = string
  })

  sensitive = true
}

data "http" "setSonarrRootFolder" {
  url = "http://192.168.1.12:${var.app.node_port}/api/v3/rootfolder"
  method = "POST"
  request_headers = {
    "Content-Type": "application/json",
    "X-Api-Key": var.app.api_key
  }  
  request_body = jsonencode({
    "path": "/drive/library/${var.app.folder}"
  })
}