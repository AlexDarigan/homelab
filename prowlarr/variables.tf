variable "kubeconfig" {
  type = string
}

variable "volumes" {
  type = object({
  config = object({
    name          = string
    mount_path    = string
  })
})
}

variable "replicas" {
  type = number
}

variable "deployment_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "container" {
  type = object({
    name = string
    image = string
  })
}

variable "ports" {
  type = object({
    container = number
    service = number
  })
}

variable "service_type" {
  type = string
}

variable "env" {
  type = object({
    puid = object ({
      name = string
      value = string
    })
    pgid = object({
      name = string
      value = string
    })
    tz = object({
      name = string
      value = string
    })
  })
}