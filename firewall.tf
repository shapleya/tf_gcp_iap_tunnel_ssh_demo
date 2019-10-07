#### google netblocks retriever module ###
module "gcp_netblocks" {
  source = "./modules/gcp_ranges"
}



### Bastion ###

##### INGRESS ##### 

resource "google_compute_firewall" "allow_bastion_vm_iap_ingress" {
  provider = "google-beta"

  name    = "allow-bastion-vm-iap-ingress"
  network = "${module.vpc_network.network_self_link}"

  target_tags = ["${var.bastion_tag}"]

  direction = "INGRESS"

  enable_logging = true

  allow {
    protocol = "tcp"
    ports    = [
      "22"
    ]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}

##### EGRESS #####


resource "google_compute_firewall" "allow_bastion_vm_egress" {
  provider = "google-beta"

  name    = "allow-bastion-internet-egress"
  network = "${module.vpc_network.network_self_link}"

  target_tags = ["${var.bastion_tag}"]

  direction = "EGRESS"

  enable_logging = true

  allow {
    protocol = "tcp"
  }
  destination_ranges = "${module.gcp_netblocks.cidr_blocks_ipv4}"
}

### Backend ###

##### INGRESS ##### 

resource "google_compute_firewall" "allow_backend_vm_ssh_ingress_from_bastion_account" {
  provider = "google-beta"

  name    = "allow-backend-vm-ssh-ingress"
  network = "${module.vpc_network.network_self_link}"

  source_service_accounts = ["${google_service_account.bastion_account_sa.email}"]
  
  direction = "INGRESS"

  enable_logging = true

  allow {
    protocol = "tcp"
    ports    = [
      "22"
    ]
  }
}


### Generalised ###
### Default Deny All ###


resource "google_compute_firewall" "deny_all_egress" {
  provider  = "google-beta"

  name      = "lab-deny-all-egress"
  network   = "${module.vpc_network.network_self_link}"
  direction = "EGRESS"
  priority  = 10000

  enable_logging = true

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }

  destination_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "deny_all_ingress" {
  provider  = "google-beta"

  name      = "lab-deny-all-ingress"
  network   = "${module.vpc_network.network_self_link}"
  direction = "INGRESS"
  priority  = 10000

  enable_logging = true

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }

  source_ranges = ["0.0.0.0/0"]
}
