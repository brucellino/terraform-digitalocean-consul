# Main definition
data "digitalocean_vpc" "selected" {
  name = var.vpc_name
}

data "digitalocean_project" "p" {
  name = var.project_name
}
data "digitalocean_image" "ubuntu" {
  slug = "ubuntu-20-04-x64"
}

data "vault_generic_secret" "join_token" {
  path = "digitalocean/tokens"
}

data "http" "ssh_key" {
  url = var.ssh_public_key_url
}

resource "digitalocean_ssh_key" "consul" {
  name       = "Consul servers ssh key"
  public_key = data.http.ssh_key.response_body
  lifecycle {
    precondition {
      condition     = contains([201, 200, 204], data.http.ssh_key.status_code)
      error_message = "Status code is not OK"
    }
  }
}

data "http" "consul_health" {
  url = join("", ["http://", digitalocean_loadbalancer.external.ip, "/v1/health/service/consul"])
  lifecycle {
    postcondition {

      condition     = contains([201, 200, 204, 503], self.status_code)
      error_message = "Consul service is not healthy"
    }
  }
}

resource "random_id" "key" {
  byte_length = 32
}

resource "digitalocean_volume" "consul_data" {
  count                   = var.servers
  region                  = data.digitalocean_vpc.selected.region
  name                    = "consul-data-${count.index}"
  size                    = "1"
  initial_filesystem_type = "ext4"
  description             = "Persistent data for Consul server ${count.index}"
}

resource "digitalocean_droplet" "server" {
  count         = var.servers
  image         = data.digitalocean_image.ubuntu.slug
  name          = "consul-${count.index}"
  region        = data.digitalocean_vpc.selected.region
  size          = var.droplet_size
  vpc_uuid      = data.digitalocean_vpc.selected.id
  ipv6          = false
  backups       = false
  monitoring    = true
  tags          = ["consul-server", "auto-destroy"]
  ssh_keys      = [digitalocean_ssh_key.consul.id]
  droplet_agent = true
  volume_ids    = [tostring(digitalocean_volume.consul_data[count.index].id)]
  user_data = templatefile(
    "${path.module}/templates/userdata.tftpl",
    {
      consul_version = tostring(var.consul_version)
      server         = true
      username       = var.username
      datacenter     = var.datacenter
      servers        = var.servers
      ssh_pub_key    = data.http.ssh_key.response_body
      tag            = "consul-server"
      region         = data.digitalocean_vpc.selected.region
      join_token     = data.vault_generic_secret.join_token.data["autojoin_token"]
      encrypt        = random_id.key.b64_std
      domain         = digitalocean_domain.cluster.name
      project        = data.digitalocean_project.p.name
      count          = count.index
    }
  )
  connection {
    type = "ssh"
    user = "root"
    host = self.ipv4_address
  }
  provisioner "remote-exec" {
    script = "${path.module}/provision/start-consul.sh"
  }
  # lifecycle {
  #   postcondition {
  #     condition     = contains([201, 200, 204], data.http.consul_health.status_code)
  #     error_message = "Consul service is not healthy"
  #   }
  # }
}

resource "digitalocean_droplet" "agent" {
  count         = var.agents
  image         = data.digitalocean_image.ubuntu.slug
  name          = "consul-agent-${count.index}"
  region        = data.digitalocean_vpc.selected.region
  size          = var.droplet_size
  vpc_uuid      = data.digitalocean_vpc.selected.id
  ipv6          = false
  backups       = false
  monitoring    = true
  tags          = ["consul-agent", "auto-destroy"]
  ssh_keys      = [digitalocean_ssh_key.consul.id]
  droplet_agent = true
  user_data = templatefile(
    "${path.module}/templates/userdata.tftpl",
    {
      consul_version = "${var.consul_version}"
      server         = false
      username       = var.username
      datacenter     = var.datacenter
      servers        = var.servers
      ssh_pub_key    = data.http.ssh_key.response_body
      tag            = "consul-server"
      region         = data.digitalocean_vpc.selected.region
      join_token     = data.vault_generic_secret.join_token.data["autojoin_token"]
      encrypt        = random_id.key.b64_std
      domain         = digitalocean_domain.cluster.name
      project        = data.digitalocean_project.p.name
      count          = count.index
    }
  )
}
resource "digitalocean_firewall" "consul" {
  name        = "consul"
  droplet_ids = concat(digitalocean_droplet.server[*].id, digitalocean_droplet.agent[*].id)

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "1-65535"
    source_load_balancer_uids = [digitalocean_loadbalancer.external.id]
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_tags = ["consul-server", "consul-agent"]
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "1-65535"
    source_tags = ["consul-server", "consul-agent"]
  }
  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
  }
  outbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
  }
}

resource "digitalocean_firewall" "ssh" {
  name        = "ssh"
  droplet_ids = concat(digitalocean_droplet.server[*].id, digitalocean_droplet.agent[*].id)

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_inbound_source_cidrs
  }

  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    #tfsec:ignore:digitalocean-compute-no-public-egress
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "digitalocean_loadbalancer" "external" {
  name     = "consul-external"
  region   = data.digitalocean_vpc.selected.region
  vpc_uuid = data.digitalocean_vpc.selected.id
  forwarding_rule {
    entry_port  = 80
    target_port = 8500
    #tfsec:ignore:digitalocean-compute-enforce-https
    entry_protocol  = "http"
    target_protocol = "http"
  }


  # forwarding_rule {
  #   entry_port       = 443
  #   target_port      = 8500
  #   entry_protocol   = "https"
  #   target_protocol  = "http"
  #   certificate_name = digitalocean_certificate.cert.name
  # }

  healthcheck {
    # https://www.consulproject.io/api-docs/system/health
    protocol               = "http"
    port                   = 8500
    path                   = "/v1/health/checks/consul"
    check_interval_seconds = 10
    healthy_threshold      = 3
  }

  # droplet_ids = digitalocean_droplet.server[*].id
  droplet_tag = "consul-server"
  # redirect_http_to_https = true
}

resource "digitalocean_domain" "cluster" {
  name = "hashi.local"
}

resource "digitalocean_record" "server" {
  count  = var.servers
  type   = "A"
  value  = digitalocean_droplet.server[count.index].ipv4_address_private
  name   = digitalocean_droplet.server[count.index].name
  domain = digitalocean_domain.cluster.name
}

resource "digitalocean_project_resources" "server_droplets" {
  project   = data.digitalocean_project.p.id
  resources = digitalocean_droplet.server[*].urn
}
resource "digitalocean_project_resources" "agent_droplets" {
  project   = data.digitalocean_project.p.id
  resources = digitalocean_droplet.agent[*].urn
}

resource "digitalocean_project_resources" "consul_volumes" {
  depends_on = [digitalocean_project_resources.agent_droplets]
  project    = data.digitalocean_project.p.id
  resources  = digitalocean_volume.consul_data[*].urn
}


resource "digitalocean_project_resources" "network" {

  project = data.digitalocean_project.p.id

  resources = [
    digitalocean_loadbalancer.external.urn,
    digitalocean_domain.cluster.urn
  ]
}
