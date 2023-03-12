terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.13.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.26.0"
    }
  }
  backend "consul" {
    path = "terraform/modules/tfmod-digitalocean-vpc"
  }
}

provider "vault" {
  # Configuration options
}

data "vault_generic_secret" "do" {
  path = "kv/do"
}

provider "digitalocean" {
  token = data.vault_generic_secret.do.data["token"]
}

module "vpc" {
  source   = "brucellino/vpc/digitalocean"
  version  = "1.0.3"
  vpc_name = "consultest"
  project = {
    description = "Consul Test project"
    environment = "development"
    name        = "consulTest"
    purpose     = "Personal"
  }
}

module "consul" {
  depends_on   = [module.vpc]
  source       = "../../"
  servers      = 1
  agents       = 1
  vpc_name     = "consultest"
  project_name = "consulTest"
}
