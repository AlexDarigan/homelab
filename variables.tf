variable "RASPI_SSH_CONFIG" {
  type = string
  sensitive = true
}

variable "KUBECONFIG" {
  type = string
  sensitive = true
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