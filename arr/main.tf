variable "KUBECONFIG" {
  type = string
  sensitive = true
}

// Move Media Management
module "radarr" {
    KUBECONFIG = var.KUBECONFIG
    name = "radarr"
    source = "./core"
    image = "ghcr.io/hotio/radarr"    
    ports = {
        internal = 7878
        external = 7878
        node_port = 30001
    }
}

// Television Media Management
module "sonarr" {
    KUBECONFIG = var.KUBECONFIG
    name = "sonarr"
    source = "./core"
    image = "ghcr.io/hotio/sonarr"    
    ports = {
        internal = 8989
        external = 8989
        node_port = 30002
    }
}

// Torrent Indexer Management
module "prowlarr" {
  KUBECONFIG = var.KUBECONFIG
  name = "prowlarr"
  source = "./core"
  image = "gchr.io/hotio/prowlarr"
  ports = {
    internal = 9696
    external = 9696
    node_port = 30003
  }
}

// Media Request Management
module "jellyseerr" {
  KUBECONFIG = var.KUBECONFIG
  name = "jellyseer"
  source = "./core"
  image = "ghcr.io/hotio/jellyseerr"
  ports = {
    internal = 5055
    external = 5055
    node_port = 30004
  }
}

// Torrent Mangement
module "QBitTorrent" {
  KUBECONFIG = var.KUBECONFIG
  name = "QBitTorrent"
  source = "./core"
  image = "ghcr.io/hotio/qbittorrent"
  ports = {
    internal = 8080
    external = 8080
    node_port = 30005
  }
}