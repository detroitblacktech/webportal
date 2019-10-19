provider "digitalocean" {
    token = "${var.do_token}"
}


data "digitalocean_ssh_key" "ssh_key" {
  name = "dopensource-training"
}


resource "digitalocean_droplet" "kamailio-server" {
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
        timeout = "5m"
        }

        provisioner "remote-exec" {
          inline = [
          "export PATH=$PATH:/usr/bin",
          # install git repo and and server up the index page
          "sudo mkdir -p ~/bits/kamailio",
          "sudo apt-get update; sudo apt-get install -y git gcc g++ flex bison default-libmysqlclient-dev make autoconf mariadb-server",
          "sleep 20",
          "cd ~/bits",
	  "git clone --depth 1 --no-single-branch https://github.com/kamailio/kamailio -b 5.3 kamailio",
	  "cd ~/;git clone https://github.com/dOpensource/kamailio-admin-training",
          "sleep 20",
        ]

      }
}



#resource "digitalocean_record" "A-staging" {
#  domain = "detroitblacktech.org"
#  type = "A"
#  name = "staging"
#  value = "${digitalocean_droplet.webserver.ipv4_address}"
#}
