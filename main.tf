terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.7.2"
    }
    time = {
      source = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

locals {
  connection = jsondecode(file(var.RASPI_SSH_CONFIG))
  config = jsondecode(file("config.json"))
  requests = jsondecode(file("requests.json"))
}

provider "kubernetes" {
    config_path = var.KUBECONFIG
}

# module "install_k3s" {
#   source = "./install"
#   host = local.connection.host
#   user = local.connection.user
#   type = local.connection.type
#   agent = local.connection.agent
# }

// We can use kubectl to extract api keys after setup and run the http queries
// Check if python has kubectl package
module "starr" {
  source = "./starr"
  for_each = local.config.apps
  model = each.value
  env = local.config.env

}

resource "time_sleep" "wait_for_service" {
  # Only use if you absolutely cannot implement a proper readiness check
  create_duration = "60s" # Wait for 60 seconds

  # This makes the sleep run after module_a, and then module_b depends on the sleep
  depends_on = [module.starr]
}

module "add_prowlarr_app" {
  source = "./requests/add/application"
  for_each = local.requests.apps
  request = each.value
  prowlarr = module.starr["prowlarr"].app
  application = module.starr[each.key].app
  
  depends_on = [ 
    time_sleep.wait_for_service
  ]  
}

module "add_download_client" {
  source = "./requests/add/download_client"
  for_each = local.requests.download_client
  request = each.value
  transmission = module.starr["transmission"].app
  application = module.starr[each.key].app

  depends_on = [ 
    time_sleep.wait_for_service
  ]  
}
