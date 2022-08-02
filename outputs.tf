output "server_public_ips" {
  value = digitalocean_droplet.server[*].ipv4_address
}

output "agent_public_ips" {
  value = digitalocean_droplet.agent[*].ipv4_address
}

output "load_balancer_ip" {
  value = digitalocean_loadbalancer.external.ip
}
