## Terraform & Packer demo - GCP

Welcome to the Terraform & Packer demo repository.

This repository serves as a sample Terraform and Packer configuration to automate the building of machine OS images and provision cloud resources accross AWS and GCP cloud providers.

## Usage

### Terraform

**Initial setup**

 1. Login in Terraform Cloud
 2. Create an organization to structure your workspaces and projects layout according to your needs.
 3. Setup two workspaces: One workspace destined to AWS resources, one for GCP resources.
 4. Create a variable set for AWS and insert AWS execution variables according to your access level and privileges in your AWS account.
 5. Create a variable set for GCP and insert GCP execution variables according to your access level and privileges in your GCP account.

**Execution**

 1. Export AWS credentials as environment variables or inside your credentials file at `$HOME/.aws/` folder
 2. Authenticate in your GCP account via your CLI, get the path of your json credentials file, and export the `GOOGLE_APPLICATION_CREDENTIALS` with this file credentials.
 3. Run `terraform init` to set up your working environment with the correct providers
 4. Create a `terraform.tfvars` from the empty `terraform.tfvars.clear` file with the corresponding values of each cloud provider.
 4. Run `terraform fmt` and `terraform validate` to update your hcl files format and check for syntax and validation errors.
 6. Run `terraform plan` and `terraform apply`. Review the execution plan to understand if the resources to be deployed match your configuration.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.21.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.21.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.82.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acme_cloud_router"></a> [acme\_cloud\_router](#module\_acme\_cloud\_router) | terraform-google-modules/cloud-router/google | ~> 6.0 |
| <a name="module_acme_vpc"></a> [acme\_vpc](#module\_acme\_vpc) | terraform-google-modules/network/google | ~> 9.0 |
| <a name="module_compute_instance"></a> [compute\_instance](#module\_compute\_instance) | terraform-google-modules/vm/google//modules/compute_instance | ~> 11.0 |
| <a name="module_instance_template"></a> [instance\_template](#module\_instance\_template) | terraform-google-modules/vm/google//modules/instance_template | ~> 11.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.frontend](https://registry.terraform.io/providers/hashicorp/google/5.21.0/docs/resources/compute_address) | resource |
| [google_compute_firewall.admin_access_iap](https://registry.terraform.io/providers/hashicorp/google/5.21.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.vpc_access_tcp](https://registry.terraform.io/providers/hashicorp/google/5.21.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.vpc_access_tcp_egress](https://registry.terraform.io/providers/hashicorp/google/5.21.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.vpc_access_udp_egress](https://registry.terraform.io/providers/hashicorp/google/5.21.0/docs/resources/compute_firewall) | resource |
| [null_resource.auto_private_subnet_cidrs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.auto_public_subnet_cidrs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_service_account.acme_tf](https://registry.terraform.io/providers/hashicorp/google/5.21.0/docs/data-sources/service_account) | data source |
| [hcp_packer_artifact.gcp_ubuntu_acme_frontend_img](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_artifact) | data source |
| [hcp_packer_version.ubuntu_acme_frontend](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR block to associate with the VPC | `string` | `"10.200.0.0/24"` | no |
| <a name="input_default_labels"></a> [default\_labels](#input\_default\_labels) | Project-scoped labels. | <pre>object({<br>    environment = string<br>    version     = number<br>    owner       = string<br>  })</pre> | <pre>{<br>  "environment": "lab",<br>  "owner": "acme",<br>  "version": 0<br>}</pre> | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP Region | `string` | `"us-central1"` | no |
| <a name="input_hcp_bucket_acme_images"></a> [hcp\_bucket\_acme\_images](#input\_hcp\_bucket\_acme\_images) | HCP Packer bucket name for hashicups image | `string` | `"base-ubuntu-amd64-img"` | no |
| <a name="input_hcp_channel"></a> [hcp\_channel](#input\_hcp\_channel) | HCP Packer channel name | `string` | `"development"` | no |
| <a name="input_instance_labels"></a> [instance\_labels](#input\_instance\_labels) | instance-scoped labels. | <pre>object({<br>    arch     = string<br>    version  = number<br>    service  = string<br>    tier     = string<br>    protocol = string<br>  })</pre> | <pre>{<br>  "arch": "amd64",<br>  "protocol": "http",<br>  "service": "web",<br>  "tier": "frontend",<br>  "version": 0<br>}</pre> | no |
| <a name="input_network_instance_tags"></a> [network\_instance\_tags](#input\_network\_instance\_tags) | network-instance-scoped tags. | `list(string)` | <pre>[<br>  "acme",<br>  "lab"<br>]</pre> | no |
| <a name="input_num_instances"></a> [num\_instances](#input\_num\_instances) | Number of VM instances to create. | `number` | `1` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of zones | `list(string)` | <pre>[<br>  "10.200.15.0/24"<br>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project id | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of zones | `list(string)` | <pre>[<br>  "10.200.10.0/24"<br>]</pre> | no |
| <a name="input_vpc_options"></a> [vpc\_options](#input\_vpc\_options) | Global VPC options | <pre>object({<br>    mtu               = number<br>    routing_mode      = string<br>    delete_igw_routes = bool<br>  })</pre> | <pre>{<br>  "delete_igw_routes": true,<br>  "mtu": 1460,<br>  "routing_mode": "GLOBAL"<br>}</pre> | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of zones in the region | `list(string)` | <pre>[<br>  "us-central1-a"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->