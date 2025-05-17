terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25" # Or your desired version
    }
  }
}

variable "kubeconfig" {
  type = string
}

provider "kubernetes" {
    config_path = var.kubeconfig
}

# Define the website content as a ConfigMap
resource "kubernetes_config_map" "website_content" {
  metadata {
    name = var.app_name
  }
  data = {
    "index.html" = <<EOF
    <!DOCTYPE html>
    <html>
    <head>
      <title>Hello from Kubernetes!</title>
    </head>
    <body>
      <h1>Hello from a simple website deployed with Terraform!</h1>
      <p>Served by Nginx in a Kubernetes Pod.</p>
      <br>
      <p>${var.greeting}</p>
    </body>
    </html>
    EOF
  }
}

# Define the Deployment for the Nginx container
resource "kubernetes_deployment" "website_deployment" {
  metadata {
    name = var.deployment_name
    labels = {
      app = var.app_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
          volume_mount {
            name      = "html-volume"
            mount_path = "/usr/share/nginx/html"
            read_only = true
          }
        }
        volume {
          name = "html-volume"
          config_map {
            name = kubernetes_config_map.website_content.metadata.0.name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }
      }
    }
  }
}

# Define the Service to expose the Deployment
resource "kubernetes_service" "website_service" {
  metadata {
    name = var.service_name
  }
  spec {
    selector = {
      app = var.app_name
    }
    port {
      port        = 80
      node_port   = var.node_port
    }
    type = "NodePort" # Use "NodePort" if LoadBalancer is not available
  }
}