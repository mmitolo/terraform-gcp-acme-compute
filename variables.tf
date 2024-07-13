variable "gcp_region" {
  type        = string
  description = "GCP Region"
  default     = "us-central1"
}

variable "project_id" {
  type        = string
  description = "GCP Project id"
}

variable "default_labels" {
  type = object({
    environment = string
    version     = number
    owner       = string
  })
  description = "Project-scoped labels."
  default = {
    environment = "lab"
    owner       = "acme"
    version     = 0
  }
}

variable "num_instances" {
  type        = number
  description = "Number of VM instances to create."
  default     = 1
}

variable "instance_labels" {
  type = object({
    arch     = string
    version  = number
    service  = string
    tier     = string
    protocol = string
  })
  description = "instance-scoped labels."
  default = {
    arch     = "amd64"
    version  = 0
    service  = "web"
    tier     = "frontend"
    protocol = "http"
  }
}

variable "network_instance_tags" {
  type        = list(string)
  description = "network-instance-scoped tags."
  default     = ["acme", "lab"]
}

variable "public_subnets" {
  type        = list(string)
  description = "define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of zones"
  default     = ["10.200.10.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of zones"
  default     = ["10.200.15.0/24"]
}

variable "vpc_options" {
  type = object({
    mtu               = number
    routing_mode      = string
    delete_igw_routes = bool
  })
  description = "Global VPC options"
  default = {
    mtu               = 1460
    routing_mode      = "GLOBAL"
    delete_igw_routes = true
  }
}

variable "zones" {
  type        = list(string)
  description = "A list of zones in the region"
  default     = ["us-central1-a"]
}

variable "cidr" {
  type        = string
  description = "CIDR block to associate with the VPC"
  default     = "10.200.0.0/24"
}

#variable "hcp_client_id" {
#  type = string
#  description = "HashiCorp Cloud Platform client ID"
#}
#
#variable "hcp_client_secret" {
#  type = string
#  description = "HashiCorp Cloud Platform client secret"
#}

#variable "hcp_bucket_acme_images" {
#  type        = string
#  description = "HCP Packer bucket name for hashicups image"
#  default     = "acme-corp-image-mgmt"
#}
#
#variable "hcp_channel" {
#  type        = string
#  description = "HCP Packer channel name"
#  default     = "development"
#}
