terraform {
  cloud {
    organization = "acme-corp-hcp"

    workspaces {
      name = "terraform-gcp-acme-compute"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.21.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.82.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "google" {
  project        = var.project_id
  region         = var.gcp_region
  default_labels = var.default_labels
}

provider "hcp" {
  project_id = "53ee78db-22e8-47ea-b253-992c709253ca"
}