
#with these locals we create a list of custom permissions in order to create a custom role.

locals {  
    group_permissions_projects_get =  [
                                      "resourcemanager.projects.get"
                                    ]
    group_permissions_cloud_iap_tunnel_resource_accessor = [
                                      "compute.zones.list",
                                      "compute.instances.get",
                                      "compute.projects.get",
                                      "compute.instances.getGuestAttributes"
                                    ]
    
    group_permissions_compute_admin = [
                                      "compute.instances.list",
                                      "compute.instances.osAdminLogin",
                                      "compute.instances.osLogin",
                                      "compute.instances.reset",
                                      "compute.instances.resume",
                                      "compute.instances.start",
                                      "compute.instances.startWithEncryptionKey",
                                      "compute.instances.stop",
                                      "compute.instances.suspend",
                                      "compute.instances.update",
                                      "compute.networks.get",
                                      "compute.networks.list",
                                      "compute.networks.use",
                                      "compute.projects.get",
                                      "compute.regions.get",
                                      "compute.regions.list",
                                    ]
}

#if we wanted to add the ability to connect to ALL instances via IAP tunnel, we need to add a custom group permission:
#### "iap.tunnelInstances.accessViaIAP"

# Here we bind our user to a single IAP-Secured Tunnel, in this case for our bastion VM instance only.

resource "google_iap_tunnel_instance_iam_binding" "iam_binding_example_iap_tunnel_user_tunnel_resource_accessor_role" {
  provider    = "google-beta"
  instance    = "${google_compute_instance.my_bastion_server.name}"
  zone        = "${google_compute_instance.my_bastion_server.zone}"
  role        = "roles/iap.tunnelResourceAccessor"
  members     = ["user:${var.example_iap_tunnel_user_email}"]
}

#Create the custom role to allow IAP prerequisites, and a simple level of compute admin access, using locals defined earlier.
resource "google_project_iam_custom_role" "compute_admin_custom_role" {
  project     = "${var.gcp_project_id}"
  role_id     = "computeadmincustom"
  title       = "[Custom] Compute Admin access"
  description = "Permissions required to administer compute resources"

  permissions = "${distinct(concat(
                          local.group_permissions_projects_get,
                          local.group_permissions_compute_admin,
                          local.group_permissions_cloud_iap_tunnel_resource_accessor
                          ))}"
}
#local.group_permissions_cloud_iap_tunnel_resource_accessor

#Assign the custom role to our user
resource "google_project_iam_binding" "project_iam_binding_role_compute_admin" {
  project     = "${var.gcp_project_id}"
  role        = "projects/${var.gcp_project_id}/roles/computeadmincustom"
  members     = ["user:${var.example_iap_tunnel_user_email}"]
  depends_on  = ["google_project_iam_custom_role.compute_admin_custom_role"]
}
