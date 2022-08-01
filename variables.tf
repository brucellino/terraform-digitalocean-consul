# consul-digitalocean variables.tf
variable "vpc" {
  type        = string
  description = "VPC we are deploying into"
}

variable "servers" {
  type        = number
  default     = 3
  description = "number of server instances"
}
variable "agents" {
  type        = number
  default     = 7
  description = "number of agent instances"
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
}

variable "ssh_public_key_url" {
  type        = string
  description = "URL of of the public ssh key to add to the droplet"
  default     = "https://github.com/brucellino.keys"
}

variable "droplet_size" {
  type        = string
  description = "Size of the droplet for Vault instances"
  default     = "s-1vcpu-1gb"
}

variable "username" {
  type        = string
  description = "Name of the non-root user to add"
  default     = "hashiuser"
}

variable "datacenter" {
  type        = string
  description = "Name of the Consul datacenter"
  default     = "HashiDO"
}
