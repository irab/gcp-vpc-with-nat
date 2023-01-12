module "network" {
  source = "./network/"

  env             = var.env
  env_folder_id   = var.env_folder_id
  billing_account = var.billing_account
  regions                                    = var.regions
  cloudsql_private_service_connection_config = var.cloudsql_private_service_connection_config

}
