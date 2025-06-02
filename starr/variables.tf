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
    })),
    env = list(object({
      name = string,
      value = string,
    }))
  })
}