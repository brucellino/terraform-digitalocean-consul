# consul-digitalocean variables.tf
variable "servers" {
  type        = number
  default     = 3
  description = "number of server instances"
  # validation = must be prime number less than 7
}
variable "agents" {
  type        = number
  default     = 7
  description = "number of agent instances"
  # validation = must be > 0
}

variable "project_name" {
  type        = string
  default     = "hashi"
  description = "Name of the project in digitalocean"
}

variable "vpc_name" {
  type        = string
  default     = "hashi"
  description = "Name of the VPC we are deploying into"
}

variable "ssh_inbound_source_cidrs" {
  type        = list(any)
  description = "List of CIDRs from which we will allow ssh connections on port 22"
  default     = []
  # validation = must not be 0.0.0.0/0
}

variable "ssh_public_key_url" {
  type        = string
  description = "URL of of the public ssh key to add to the droplet"
  default     = "https://github.com/brucellino.keys"
  # Pre-condition in data.
}

variable "droplet_size" {
  type        = string
  description = "Size of the droplet for Vault instances"
  default     = "s-1vcpu-1gb"
  # validation = must be in digitalocean droplet sizes
}

variable "username" {
  type        = string
  description = "Name of the non-root user to add"
  default     = "hashiuser"
}

variable "consul_version" {
  description = "Version of Consul to deploy"
  type        = string
  default     = "1.12.3"
}

variable "datacenter" {
  type        = string
  description = "Name of the Consul datacenter"
  default     = "HashiDO"
}
