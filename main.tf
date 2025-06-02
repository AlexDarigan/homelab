// Install K3S if not already there, using calico, maybe a different script?
// create namespace if not exists

resource "kubernetes_namespace" "name" {
  metadata {
    name = "starr"
    labels = {
      name = "starr"
    }
  }
}

module "starr" {
  source = "./starr"
  for_each = local.apps
  model = each.value
}

resource "time_sleep" "wait_for_service" {
  # Only use if you absolutely cannot implement a proper readiness check
  create_duration = "60s" # Wait for 60 seconds

  # This makes the sleep run after module_a, and then module_b depends on the sleep
  depends_on = [module.starr]

  triggers = {
    always = timestamp()
  }
}

module "add_prowlarr_application" {
  source = "./api/application/add"
  for_each = local.add_prowlarr_application_requests
  prowlarr = module.starr["prowlarr"].app
  app = module.starr[each.value.target].app
  
  request = {
    route = each.value.route
    method = each.value.method
    content_type = each.value.content_type
    body = each.value.body
  }

  depends_on = [ time_sleep.wait_for_service ]
}

module "add_root_folders" {
  source = "./api/root_folder/add"
  for_each = local.set_root_folder_requests
  app = module.starr[each.value.app].app

  request = {
    route = each.value.route
    method = each.value.method
    content_type = each.value.content_type
    body = each.value.body
  }

  depends_on = [ time_sleep.wait_for_service ]
}

// add download client
  # Sonarr
  # api/download_clients POST 

  # Radarr
  # api/download_clients POST
