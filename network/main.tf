resource "google_project" "platform-vpc" {
  name                = "plat-vpc-${var.env}"
  project_id          = "plat-vpc-${var.env}"
  billing_account     = var.billing_account
  folder_id           = var.env_folder_id
  auto_create_network = false
}

resource "google_project_service" "enabled_services" {
  for_each = var.enabled_apis

  project = google_project.platform-vpc.project_id
  service = each.value

  disable_dependent_services = false
}

## Delay needed to allow time for the Google Managed service accounts to be created when an API service is enabled e.g. project_id@container-engine-robot.iam.gserviceaccount.com
resource "time_sleep" "wait_for_enabled_services" {
  depends_on = [google_project_service.enabled_services]

  create_duration = "60s"
}

resource "google_compute_shared_vpc_host_project" "host" {
  depends_on = [time_sleep.wait_for_enabled_services]
  project    = google_project.platform-vpc.project_id
}

resource "google_compute_network" "host_vpc" {
  depends_on = [time_sleep.wait_for_enabled_services]

  project                 = google_project.platform-vpc.project_id
  name                    = "plat-vpc-${var.env}"
  auto_create_subnetworks = false
}

resource "google_project_iam_custom_role" "modify_svpc_firewall_custom_role" {
  depends_on = [time_sleep.wait_for_enabled_services]

  project = google_project.platform-vpc.project_id

  role_id     = "SharedVPCFirewallModfier"
  title       = "Shared VPC Firewall Modifier Role"
  description = "This Custom Role contains roles to allow the container-engine-robot.iam.gserviceaccount.com service account for a service project permission to update firewall rules in a Shared VPC"
  permissions = [
    "compute.networks.updatePolicy",
    "compute.firewalls.list",
    "compute.firewalls.get",
    "compute.firewalls.create",
    "compute.firewalls.update",
    "compute.firewalls.delete",
  ]
}