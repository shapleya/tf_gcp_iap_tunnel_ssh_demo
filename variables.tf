variable "gcp_project_id" {
  description = "GCP Project ID where the example VM instance will be created"
  type        = "string"
  # Required
}

variable "gcp_region" {
  description = "GCP Region for the example machines to be built"
  type        = "string"
  # Required
}

variable "example_iap_tunnel_user_email" {
  description = "Email address of the IAM User allowed Cloud IAP-Secured Tunnel access to the example bastion VM instance"
  type        = "string"
}

variable "gce_machine_type" {
  description = "Specification of machine type for the example VM instances"
  type        = "string"
  default     = "n1-standard-1"
}
