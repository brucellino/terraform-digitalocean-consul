output "server_public_ips" {
  value = digitalocean_droplet.server[*].ipv4_address
}
