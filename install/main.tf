variable "host" {
  type = string
}

variable "user" {
  type = string
}

variable "type" {
  type = string
}

variable "agent" {
  type = bool
}

resource "null_resource" "install_k3s" {

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -s - server --flannel-backend=wireguard-native --write-kubeconfig-mode=644",
      "sleep 10s",
      "cat /etc/rancher/k3s/k3s.yaml"
    ]

    connection {
      type = var.type 
      host = var.host
      user = var.user
      // If this fails, ssh agent does not have the key
      agent = var.agent
    }
  }

#   provisioner "local-exec" {
#     command = "sudo scp ${var.user}@${var.host}:/etc/rancher/k3s/k3s.yaml ~/.kube/config.yaml"  

    
#   }

#   provisioner "local-exec" {
#     command = "sed -i 's/server: https:\\/\\/\\127\\.0\\.0\\.1:6443/server: https:\\/\\/192.168.1.12:6443/g' ~/.kube/config.yaml && chmod 600 ~/.kube/config.yaml"
#   }
}