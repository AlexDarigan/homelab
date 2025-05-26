
{
    "add_transmission": {
        "name": "Transmission",
        "enable": true,
        "implementationName": "Transmission",
        "implementation": "Transmission",
        "configContract": "TransmissionSettings",
        "infoLink": "https://wiki.servarr.com/sonarr/supported#transmission",
        "tags": [],
        "protocol": "torrent",
        "priority": 1,
        "removeCompletedDownloads": true,
        "removeFailedDownloads": true,
        "use_ssl": false,
        "tv_category": "tv-sonarr",
        "add_paused": false,
        
            {
                "name": "useSsl",
                "value": false
            },
            {
                "name": "urlBase",
                "value": "/transmission/"
            },
        ]
    }
}

variable "target_url" {
  type = string
}

variable "request" {
  type = object({
    route = string
    method = string
    content_type = string
    name = string
    implementation = string
    implementation_name = string
    config_contract = string
    enable = bool
    info_link = string
    sync_level = string
    sync_categories = list(number)
    anime_sync_categories = list(number)
    sync_anime_standard_format_search = bool
    sync_reject_blocklisted_torrent_hashes_while_grabbing = bool
    tags = list(string)
  })
}

data "http" "add_transmission_to_sonarr" {
  url    = "http://192.168.1.12:30011/${var.request.route}"
  method = var.request.method
  request_headers = {
    "Content-Type": var.request.content_type,
  }

  request_body = jsonencode({
    "name": var.request.name
    "configContract": var.request.config_contract
    "enable": var.request.enable
    "implementation": var.request.implementation
    "implementationName": var.request.implementation_name
    "infoLink": var.request.info_link
    "syncLevel": var.request.sync_level
    "tags": var.request.tags
    "protocol": var.request.protocol
    "priority": var.request.priority
    "removeCompletedDownloads": var.request.removeCompletedDownloads
    "removeFailedDownloads": var.request.removeFailedDownloads
    "fields": [
        {
            "name": "host",
            "value": var.target_url
        },
        {
            "name": replace("port", "ports"),
            "value": 9091
        },
        {
            "name": "use_ssl",
            "value": false
        }
        {
            "name": "tv_category",
            "value": "tv-sonarr",
        }
        {
            "name": "add_paused",
            "value": false
        }
        {
            "tv_category": "tv-sonarr",
            "add_paused": false
        }
    ],
  })
}