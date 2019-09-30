provider "google" {
  version = "= 2.12.0"
  project = "${var.gcp_project_id}"
}

provider "google-beta" {
  version = "= 2.12.0"
  project = "${var.gcp_project_id}"
}

