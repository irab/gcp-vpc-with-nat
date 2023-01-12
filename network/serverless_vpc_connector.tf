resource "google_vpc_access_connector" "serverless_connector" {
  project = google_project.platform-vpc.project_id

  for_each = {
    for k, v in var.regions : k => v.serverless_connector
  }

  name           = "subnet-svlscon-${var.env}-${each.value.region_short}"
  provider       = google-beta
  region         = each.key
  ip_cidr_range  = each.value.subnet_cidr
  max_throughput = 300
  network        = google_compute_network.host_vpc.id
}
