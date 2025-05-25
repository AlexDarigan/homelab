variable "model" {
  type = object({
    name = string
    image = string
    namespace = string
    replicas = number
    service_type = string
    ports = list(object({
      name = string
      protocol = string
      internal = number
      external = number
      node = number
    })),
    volumes = list(object({
      name = string
      mount_path = string
      host_path = string
    }))
  })
}

variable "env" {
  type = list(object({
    name = string
    value = string
  }))
}

locals {
  app_name = "${var.model.name}-app"
  container_name = "${var.model.name}-container"
  deployment_name = "${var.model.name}-deployment"
  service_name = "${var.model.name}-service"
}
