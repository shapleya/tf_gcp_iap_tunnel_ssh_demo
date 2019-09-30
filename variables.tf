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

variable "gce_bastion_service_account_name" {
  description = "Prefix Name for Bastion service account"
  type        = "string"
  default     = "bastion-service"
}

variable "network_name" {
  description = "Name for VPC network"
  type        = "string"
  default     = "labnetwork"
}

variable "subnet_bastion_name" {
  description = "Name for subnetwork"
  type        = "string"
  default     = "bastion-subnet"
}

variable "subnet_bastion_cidr" {
  description = "Ip range for subnetwork"
  type        = "string"
  default     = "10.10.0.0/24"
}

variable "bastion_tag" {
  description = "Network Tag for bastion host"
  type        = "string"
  default     = "bastion-tag"
}

variable "backend_tag" {
  description = "Network Tag for bastion host"
  type        = "string"
  default     = "backend-tag"
}

variable "subnet_backend_name" {
  description = "Name for subnetwork"
  type        = "string"
  default     = "backend-subnet"
}

variable "subnet_backend_cidr" {
  description = "Ip range for subnetwork"
  type        = "string"
  default     = "10.100.0.0/24"
}