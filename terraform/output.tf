output "ip" {
  value = "${digitalocean_droplet.webserver.*.ipv4_address}"
}
