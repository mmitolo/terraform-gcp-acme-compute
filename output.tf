output "ubuntu_acme_frontend" {
  value = data.hcp_packer_version.ubuntu_acme_frontend
}

output "gcp_ubuntu_acme_frontend_img" {
  value = data.hcp_packer_artifact.gcp_ubuntu_acme_frontend_img
}

output "gcp_instance_details" {
  value = module.compute_instance.instances_details
}
