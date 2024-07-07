terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

data "digitalocean_ssh_key" "default" {
  name = "SergeyMacAir"
}

resource "digitalocean_droplet" "web" {
  image    = "ubuntu-20-04-x64"
  name     = "web-server"
  region   = "nyc1"
  size     = "s-2vcpu-4gb"
  backups  = false
  ipv6     = true
  vpc_uuid = "e9a6e9f9-d893-4121-b7be-aa2a2a831ef0"

  ssh_keys = [
    data.digitalocean_ssh_key.default.id
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "while sudo fuser /var/lib/dpkg/lock-frontend ; do sleep 1 ; done",
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
      "apt-get update",
      "apt-get install -y docker-ce",
      "apt-get install -y docker-compose",
      "systemctl start docker",
      "systemctl enable docker",
      "groupadd docker || true",
      "useradd -m -s /bin/bash -p $(openssl passwd -1 ololo) user",
      "usermod -aG docker user",
      "mkdir -p /home/user/.ssh",
      "cp /root/.ssh/authorized_keys /home/user/.ssh/authorized_keys",
      "chown -R user:user /home/user/.ssh",
      "chmod 700 /home/user/.ssh",
      "chmod 600 /home/user/.ssh/authorized_keys"
    ]
  }

  tags = ["web"]
}