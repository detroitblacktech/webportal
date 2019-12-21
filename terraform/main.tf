provider "digitalocean" {
    token = "${var.do_token}"
}


data "digitalocean_ssh_key" "ssh_key" {
  name = "dbt_dev"
}


resource "digitalocean_droplet" "webserver" {
        name = "${var.dropletname}-${count.index}"
        count = "${var.number_of_servers}"
        region = "nyc1"
        size="1gb"
        image="debian-9-x64"
              ssh_keys = [ "${data.digitalocean_ssh_key.ssh_key.fingerprint}" ]

        connection {
        user = "root"
        type = "ssh"
        private_key = "${file(var.pvt_key)}"
        timeout = "10m"
        }

        provisioner "remote-exec" {
          inline = [
          "export PATH=$PATH:/usr/bin",
          # install git repo and and server up the index page
          "sudo apt-get update",
          "sleep 60",
          "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common git",
          "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
	  "sleep 20",
          "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debiani $(lsb_release -cs) stable\"",
          "sudo apt-get update",
          "sleep 20",
          "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
          "sleep 80",
          "git clone ${var.repo} -b ${var.branch}",
          "cd webportal",
          "./deploy.sh docker",
          "sleep 20"
        ]

      }
}



resource "digitalocean_record" "A-staging" {
  domain = "detroitblacktech.org"
  type = "A"
  name = "staging"
  value = "${digitalocean_droplet.webserver.ipv4_address}"
}
