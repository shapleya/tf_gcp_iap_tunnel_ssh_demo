#example (backend) compute instance
resource "google_compute_instance" "my_backend_server" {
  name         = "my-backend-server"
  zone         = "${var.gcp_region}-b"
  machine_type = "${var.gce_machine_type}"

  deletion_protection = false

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  
  network_interface {
    #no public IP by default
    network     = "${module.vpc_network.network_self_link}"
    subnetwork  = "${module.vpc_network.subnets_self_links[1]}"
  }
}

#example (bastion) compute instance
resource "google_compute_instance" "my_bastion_server" {
  name         = "my-bastion-server"
  zone         = "${var.gcp_region}-b"
  machine_type = "${var.gce_machine_type}"

  deletion_protection = false

  allow_stopping_for_update = true

  tags = ["${var.bastion_tag}"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  service_account {
    email  = "${google_service_account.bastion_account_sa.email}"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
      ]
  }
  
  network_interface {
    #no public IP by default
    network = "${module.vpc_network.network_self_link}"
    subnetwork  = "${module.vpc_network.subnets_self_links[0]}"
  }
}
