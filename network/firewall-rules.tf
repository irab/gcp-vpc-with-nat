resource "google_compute_firewall" "allow-ingress-tcp-port443" {
  name      = "allow-ingress-tcp-port443"
  project   = "plat-vpc-${var.env}"
  network   = google_compute_network.host_vpc.id
  priority  = 1000
  direction = "INGRESS"

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
    # metadata = "EXCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]
}
