output "server_public_ips" {
  description = "List of public IPs for the Consul servers"
  value       = digitalocean_droplet.server[*].ipv4_address
}

output "agent_public_ips" {
  description = "List of public IPs for the Consul agents"
  value       = digitalocean_droplet.agent[*].ipv4_address
}

output "load_balancer_ip" {
  description = "Public IP of the load balancer fronting the servers"
  value       = digitalocean_loadbalancer.external.ip
}
