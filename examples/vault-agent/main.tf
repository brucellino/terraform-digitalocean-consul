terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2"
    }
  }
  backend "consul" {
    path = "terraform/modules/tfmod-digitalocean-vpc/vault-agent"
  }
}

provider "vault" {
  # Configuration options
}

data "vault_generic_secret" "do" {
  path = "digitalocean/tokens"
}

provider "digitalocean" {
  token = data.vault_generic_secret.do.data["terraform"]
}

variable "consul_version" {
  type    = string
  default = "1.16.3"
}

module "vpc" {
  source   = "brucellino/vpc/digitalocean"
  version  = "1.0.3"
  vpc_name = "consultest-${var.consul_version}"
  project = {
    description = "Consul v${var.consul_version} Test Project"
    environment = "development"
    name        = "consulTest_v${var.consul_version}"
    purpose     = "Personal"
  }
}

module "consul" {
  depends_on               = [module.vpc]
  source                   = "../../"
  servers                  = 1
  agents                   = 1
  vpc_name                 = "consultest-${var.consul_version}"
  project_name             = "consulTest_v${var.consul_version}"
  consul_version           = var.consul_version
  ssh_inbound_source_cidrs = []
}
