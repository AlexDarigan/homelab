



data "http" "add_prowlarr_application" {
  url    = "http://192.168.1.12:30012/${var.request.route}"
  method = var.request.method
  request_headers = {
    "Content-Type": var.request.content_type,
    "X-Api-Key": var.prowlarr.api_key
  }
  request_body = local.body
}
   
        