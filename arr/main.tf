variable "KUBECONFIG" {
  type = string
  sensitive = true
}

variable "namespace" {
  type = string
  default = "arr-stack"
}

resource "kubernetes_namespace" "arr_stack" {
  metadata {
    name = var.namespace
    annotations = {
      "description" = "Namespace for the arr-stack apps (sonarr, radarr, etc)"
    }
  }
}

// Move Media Management
module "radarr" {
    KUBECONFIG = var.KUBECONFIG
    name = "radarr"
    source = "./core"
    image = "ghcr.io/hotio/radarr"    
    port = 7878
}

// Television Media Management
module "sonarr" {
    KUBECONFIG = var.KUBECONFIG
    name = "sonarr"
    source = "./core"
    image = "ghcr.io/hotio/sonarr"    
    port = 8989
}

// Torrent Indexer Management
module "prowlarr" {
  KUBECONFIG = var.KUBECONFIG
  name = "prowlarr"
  source = "./core"
  image = "lscr.io/linuxserver/prowlarr:latest" 
  # image = "gchr.io/hotio/prowlarr" // Bad Image Pull
  port = 9696
}

// Media Request Management
module "jellyseerr" {
  KUBECONFIG = var.KUBECONFIG
  name = "jellyseer"
  source = "./core"
  image = "ghcr.io/hotio/jellyseerr"
  port = 5055
}

// Torrent Mangement
module "Transmission" {
  KUBECONFIG = var.KUBECONFIG
  name = "transmission"
  source = "./core"
  image = "lscr.io/linuxserver/transmission"
  port = 9091
  replicas = 1
}
