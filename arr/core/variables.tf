variable "KUBECONFIG" {
  type = string
  default = "~./kube/config.yaml"
}

variable "name" {
  type = string
}

locals {
  app_name = "${var.name}-app"
  container_name = "${var.name}-container"
  deployment_name = "${var.name}-deployment"
  service_name = "${var.name}-service"
  
  library = object({
    name = "library"
    mount_path = "/library"
    host_path = "${var.root_host_path}/library"
  })

  config = object({
    name = "config"
    mount_path = "/config"
    host_path = "${var.root_host_path}/apps/${var.name}/config"
  })

  downloads = object({
    name = "downloads"
    mount_path = "/downloads"
    host_path = "${var.root_host_path}/apps/${var.name}/downloads"
  })

}

variable "root_host_path" {
  type = string
  default = "/drive"
}

variable "replicas" {
  type = number
  default = 2
}

variable "image" {
  type = string
}

variable "ports" {
  type = object({
    internal = number
    external = number
    node_port = number
  })
}

variable "service_type" {
  type = string
  default = "NodePort"
}

variable "restart_policy" {
  type = string
  default = "unless-stopped"
}

variable "puid" {
  type = string
  default = "1000"
}


variable "pgid" {
  type = string
  default = "1000"
}

variable "tz" {
  type = string
  default = "Etc/UTC"
}

variable "umask" {
  type = string
  default = "002"
}

variable "dns_policy" {
  type = string
  default = "None"
}

variable "nameservers" {
  type = list(string)
  default = [ "8.8.8.8", "8.8.4.4" ]
}

