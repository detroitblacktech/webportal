terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.0.1"
    }
  }
}

provider "digitalocean" {
    token = "${var.do_token}"
}


data "digitalocean_ssh_key" "ssh_key" {
  name = "dbt_dev"
}

data "digitalocean_image" "dbt_image" {
  name = "dbt_base"
}


resource "digitalocean_droplet" "webserver" {
        name = "${var.dropletname}"
        #"-${var.branch}-${count.index}"
        #count = "${var.number_of_servers}"
        region = "nyc1"
        size="1gb"
        image="${data.digitalocean_image.dbt_image.id}"
              ssh_keys = [ "${data.digitalocean_ssh_key.ssh_key.fingerprint}" ]

        connection {
        user = "root"
        type = "ssh"
        host = digitalocean_droplet.webserver.ipv4_address
        private_key = "${file(var.pvt_key)}"
        timeout = "10m"
        }

        provisioner "remote-exec" {
          inline = [
          "export PATH=$PATH:/usr/bin",
          "git clone ${var.repo} -b ${var.branch}",
          "cd webportal",
	  "export SLACK_API_TOKEN=${var.slack_api_token}",
          "./deploy.sh docker",
          "sleep 20"
        ]

      }
}



data "digitalocean_floating_ip" "dbt_production_ip" {
  ip_address = "${var.production_ip}"
}

resource "digitalocean_floating_ip_assignment" "dbt_assignment" {
  ip_address = "${data.digitalocean_floating_ip.dbt_production_ip.ip_address}"
  droplet_id = "${digitalocean_droplet.webserver.id}"
}
