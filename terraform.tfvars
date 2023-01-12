organization_id        = 123123123123
env                    = "dev"
env_folder_id          = 123123123123
billing_account        = "add billing id here"
regions = {
  "australia-southeast1" = {
    nat = {
      subnet_cidr  = "10.128.10.0/29",
      region_short = "au-se1",
    },
    serverless_connector = {
      subnet_cidr  = "10.128.16.0/28",
      region_short = "au-se1",
    }
  }
}

cloudsql_private_service_connection_config = {
  address_range = "10.128.32.0",
  prefix_length = "20",
}
