resource "google_compute_global_address" "cloudsql_private_ip_alloc" {
  provider = google-beta

  name    = "cloudsql-private-ip-alloc"
  project = google_project.platform-vpc.project_id
  purpose = "VPC_PEERING"
  address = var.cloudsql_private_service_connection_config.address_range

  address_type  = "INTERNAL"
  prefix_length = var.cloudsql_private_service_connection_config.prefix_length
  network       = google_compute_network.host_vpc.id
}

resource "google_service_networking_connection" "cloudsql_service_networking_connection" {
  provider = google-beta

  depends_on = [time_sleep.wait_for_enabled_services]

  network                 = google_compute_network.host_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_ip_alloc.name]
}
