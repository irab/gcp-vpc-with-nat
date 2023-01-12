output "vpc_id" {
  value = google_compute_network.host_vpc.id
}

output "project_id" {
  value = google_project.platform-vpc.project_id
}

#
output "svpc_name" {
  value = values(google_vpc_access_connector.serverless_connector)[*].name
}
