module "vpc_network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 1.0.0"
  project_id   = "${var.gcp_project_id}"
  network_name = "${var.network_name}"

  subnets = [
    {
      subnet_name   = "${var.subnet_bastion_name}"
      subnet_ip     = "${var.subnet_bastion_cidr}"
      subnet_region = "${var.gcp_region}"
      # Enables access to the project's private Google API's from the subnet
      subnet_private_access = "true"
    },
    {
      subnet_name   = "${var.subnet_backend_name}"
      subnet_ip     = "${var.subnet_backend_cidr}"
      subnet_region = "${var.gcp_region}"
      # Enables access to the project's private Google API's from the subnet
      subnet_private_access = "true"
    }
  ]
  secondary_ranges = {
   "${var.subnet_bastion_name}" = [],
   "${var.subnet_backend_name}" = []
  }
  routing_mode = "GLOBAL"

  delete_default_internet_gateway_routes = "false"
}
