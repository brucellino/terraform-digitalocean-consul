[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/brucellino/tfmod-template/main.svg)](https://results.pre-commit.ci/latest/github/brucellino/tfmod-template/main) [![semantic-release: conventional](https://img.shields.io/badge/semantic--release-conventional-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# tfmod-template

<!-- Delete this section when using the template repository -->

This is the template repository for my terraform modules.
It attempts to follow the [default structure](https://www.terraform.io/language/modules/develop/structure) for terraform modules.

It is designed to speed up development of new terraform modules by providing:

1. basic terraform setup for backend, providers, _etc_.
  1. the default required version for terraform is `>1.2.0`
1. common pre-commit hooks configuration
1. semantic release configuration
1. examples directory for testing and demonstration
1. default github actions workflows for testing and releasing

## How to use

<!-- Delete this section when using the template repository -->

If you want to make a new terraform module from scratch:

1. create a new repository using this one as template
1. delete the sections commented with `<!-- Delete this section when using the template repository -->`
1. update `terraform.tf` to declare the module's required providers
1. add the examples you need in `examples/<your example>`
1. update the test workflow in `.github/workflows/test.yml` to reflect your examples

## Pre-commit hooks

<!-- Edit this section or delete if you make no change  -->

The [pre-commit](https://pre-commit.com) framework is used to manage pre-commit hooks for this repository.
A few well-known hooks are provided to cover correctness, security and safety in terraform.

## Examples

The `examples/` directory contains the example usage of this module.
These examples show how to use the module in your project, and are also use for testing in CI/CD.

<!--

Modify this section according to the kinds of examples you want
You may want to change the names of the examples or the kinds of
examples themselves

-->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.2.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | 2.21.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.0.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 3.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.21.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.0.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_domain.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/domain) | resource |
| [digitalocean_droplet.agent](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/droplet) | resource |
| [digitalocean_droplet.server](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/droplet) | resource |
| [digitalocean_firewall.consul](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/firewall) | resource |
| [digitalocean_firewall.ssh](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/firewall) | resource |
| [digitalocean_loadbalancer.external](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/loadbalancer) | resource |
| [digitalocean_project_resources.agent_droplets](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources) | resource |
| [digitalocean_project_resources.consul_volumes](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources) | resource |
| [digitalocean_project_resources.network](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources) | resource |
| [digitalocean_project_resources.server_droplets](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources) | resource |
| [digitalocean_record.server](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/record) | resource |
| [digitalocean_ssh_key.consul](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/ssh_key) | resource |
| [digitalocean_volume.consul_data](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/volume) | resource |
| [random_id.key](https://registry.terraform.io/providers/hashicorp/random/3.3.2/docs/resources/id) | resource |
| [digitalocean_image.ubuntu](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/image) | data source |
| [digitalocean_project.p](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/project) | data source |
| [digitalocean_vpc.selected](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/vpc) | data source |
| [http_http.consul_health](https://registry.terraform.io/providers/hashicorp/http/3.0.1/docs/data-sources/http) | data source |
| [http_http.ssh_key](https://registry.terraform.io/providers/hashicorp/http/3.0.1/docs/data-sources/http) | data source |
| [vault_generic_secret.join_token](https://registry.terraform.io/providers/hashicorp/vault/3.8.0/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agents"></a> [agents](#input\_agents) | number of agent instances | `number` | `7` | no |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | Name of the Consul datacenter | `string` | `"HashiDO"` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size of the droplet for Vault instances | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project in digitalocean | `string` | `"hashi"` | no |
| <a name="input_servers"></a> [servers](#input\_servers) | number of server instances | `number` | `3` | no |
| <a name="input_ssh_inbound_source_cidrs"></a> [ssh\_inbound\_source\_cidrs](#input\_ssh\_inbound\_source\_cidrs) | List of CIDRs from which we will allow ssh connections on port 22 | `list(any)` | `[]` | no |
| <a name="input_ssh_public_key_url"></a> [ssh\_public\_key\_url](#input\_ssh\_public\_key\_url) | URL of of the public ssh key to add to the droplet | `string` | `"https://github.com/brucellino.keys"` | no |
| <a name="input_username"></a> [username](#input\_username) | Name of the non-root user to add | `string` | `"hashiuser"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC we are deploying into | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC we are deploying into | `string` | `"hashi"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_public_ips"></a> [agent\_public\_ips](#output\_agent\_public\_ips) | n/a |
| <a name="output_load_balancer_ip"></a> [load\_balancer\_ip](#output\_load\_balancer\_ip) | n/a |
| <a name="output_server_public_ips"></a> [server\_public\_ips](#output\_server\_public\_ips) | n/a |
<!-- END_TF_DOCS -->
