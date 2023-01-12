variable "env_folder_id" {
  description = "The Folder ID for the environment"
  type        = number
}

variable "env" {
  description = "The short name for the environment"
  type        = string
}

variable "enabled_apis" {
  description = "List of Service APIS to enable in the project"
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
  ]
  type = set(string)
}

variable "billing_account" {
  description = "The Billing Account linked to the project"
  type        = string
}

variable "regions" {
  description = "List of Regions to create clusters in Platform environments"
  type        = map(any)
}

variable "cloudsql_private_service_connection_config" {
  description = "CIDR to allocate for Private Service Connect - used to support private CloudSQL instances"
  type = object({
    address_range = string
    prefix_length = number
  })
}
