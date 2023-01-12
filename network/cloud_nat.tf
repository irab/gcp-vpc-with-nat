resource "google_compute_subnetwork" "nat_subnet" {
  project = google_project.platform-vpc.project_id

  for_each = {
    for k, v in var.regions : k => v.nat
  }

  name          = "subnet-nat-${var.env}-${each.value.region_short}"
  ip_cidr_range = each.value.subnet_cidr
  region        = each.key
  network       = google_compute_network.host_vpc.id

  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "nat_router" {
  project = google_project.platform-vpc.project_id

  for_each = {
    for k, v in var.regions : k => v.nat
  }

  name    = "nat-router-${var.env}-${each.value.region_short}"
  region  = each.key
  network = google_compute_network.host_vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  project = google_project.platform-vpc.project_id

  for_each = {
    for k, v in var.regions : k => v.nat
  }

  name                               = "plat-nat-${var.env}-${each.value.region_short}"
  router                             = "nat-router-${var.env}-${each.value.region_short}"
  region                             = each.key
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}