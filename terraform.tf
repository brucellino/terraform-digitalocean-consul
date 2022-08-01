terraform {
  required_version = ">1.2.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.8.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.0.1"
    }
  }
}
