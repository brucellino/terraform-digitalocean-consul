output "server_public_ips" {
  value = digitalocean_droplet.server[*].ipv4_address
}

output "agent_public_ips" {
  value = digitalocean_droplet.agent[*].ipv4_address
}
