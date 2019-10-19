output "kamailio-server-ssh" {
  value = "${digitalocean_droplet.kamailio-server.*.ipv4_address}"
}
