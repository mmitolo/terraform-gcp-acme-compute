locals {
  private_subnet = {
      subnet_name   = "prv-subnet"
      subnet_ip     = element(local.private_subnet_cidrs, 0)
      subnet_region = var.gcp_region
  }
  public_subnet = {
      subnet_name   = "pub-subnet"
      subnet_ip     = element(local.public_subnet_cidrs, 0)
      subnet_region = var.gcp_region
  }
  default_ingress_igw = {
      name              = "${var.default_labels.owner}-ingress-igw"
      description       = "ACME default route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = join(",", var.network_instance_tags)
      next_hop_internet = "true"
  }
  subnets = [local.public_subnet, local.private_subnet]
  routes = [local.default_ingress_igw]
}

module "acme_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = "${var.default_labels.owner}-vpc"
  mtu          = var.vpc_options.mtu
  routing_mode = var.vpc_options.routing_mode

  delete_default_internet_gateway_routes = true

  routes = local.routes

  subnets = local.subnets

}

module "acme_cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  name    = "${var.default_labels.owner}-cloudrouter"
  region  = var.gcp_region
  project = var.project_id
  network = module.acme_vpc.network_name

  nats = [{
    name                               = "${var.default_labels.owner}-ngw"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                    = module.acme_vpc.subnets["us-central1/prv-subnet"].id
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
      }
    ]
  }]
}

resource "google_compute_address" "frontend" {
  name   = "${var.default_labels.owner}-public-static-ip"
  region = var.gcp_region
}

resource "google_compute_firewall" "admin_access_iap" {
  name          = "${var.default_labels.owner}-allow-iap"
  network       = module.acme_vpc.network_name
  source_ranges = ["35.235.240.0/20"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "vpc_access_tcp" {
  name          = "${var.default_labels.owner}-allow-frontend-tcp"
  network       = module.acme_vpc.network_name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "5000"]
  }
}

resource "google_compute_firewall" "vpc_access_tcp_egress" {
  name               = "${var.default_labels.owner}-allow-frontend-tcp-eg"
  network            = module.acme_vpc.network_name
  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}


resource "google_compute_firewall" "vpc_access_udp_egress" {
  name               = "${var.default_labels.owner}-allow-frontend-udp-eg"
  network            = module.acme_vpc.network_name
  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}