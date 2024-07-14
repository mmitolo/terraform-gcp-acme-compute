locals {
  service_account = {
    email  = data.google_service_account.acme_tf.email,
    scopes = ["cloud-platform"]
  }
  access_config = [{
    nat_ip       = resource.google_compute_address.frontend.address
    network_tier = "PREMIUM"
  }]
  instances = {
    frontend = {
      subnetwork           = module.acme_vpc.subnets["us-central1/pub-subnet"].id
      name_prefix          = "${var.default_labels.owner}-vm-demo"
      machine_type         = "e2-standard-4"
      source_image_project = "acme-corp-tfc-test"
      source_image         = data.hcp_packer_artifact.gcp_ubuntu_acme_frontend_img.external_identifier
    }
  }
}

#  gcloud compute ssh --zone "us-central1-a" "acme-frontend-001" --tunnel-through-iap --project "acme-corp-gcp"
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 11.0"

  name_prefix          = local.instances.frontend.name_prefix
  region               = var.gcp_region
  project_id           = var.project_id
  subnetwork           = local.instances.frontend.subnetwork
  service_account      = local.service_account
  machine_type         = local.instances.frontend.machine_type
  source_image_project = local.instances.frontend.source_image_project
  source_image         = local.instances.frontend.source_image
  auto_delete          = true
  labels               = var.instance_labels
  tags                 = var.network_instance_tags

}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "~> 11.0"

  region              = var.gcp_region
  subnetwork          = local.instances.frontend.subnetwork
  num_instances       = var.num_instances
  hostname            = "${var.default_labels.owner}-frontend"
  instance_template   = module.instance_template.self_link
  deletion_protection = false
  access_config       = local.access_config
}