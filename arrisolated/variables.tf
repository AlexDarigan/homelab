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
  
  config = {
    name = "config"
    mount_path = "/config"
    host_path = "${var.root_host_path}/apps/${var.name}/config"
  }

  drive = {
    name = "drive"
    mount_path = "/drive"
    host_path = var.root_host_path
  }

}

variable "root_host_path" {
  type = string
  default = "/drive"
}

variable "replicas" {
  type = number
  default = 1
}

variable "image" {
  type = string
}

variable "port" {
  type = string
}

variable "service_type" {
  type = string
  default = "NodePort"
}

variable "restart_policy" {
  type = string
  default = "Always"
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

variable "namespace" {
  type = string
  default = "arr-stack"
}

variable "dns_policy" {
  type = string
  default = "None"
}

variable "host_network" {
  type = bool
  default = true
}

variable "nameservers" {
  type = list(string)
  default = [ "8.8.8.8", "8.8.4.4" ]
}

