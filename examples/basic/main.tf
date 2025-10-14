module "datastream_replication" {
  source = "../../"

  # Source type (currently only postgresql supported)
  source_type = "postgresql"

  # Required variables
  project_id        = var.project_id
  region           = var.region
  postgres_host    = var.postgres_host
  postgres_instance = var.postgres_instance
  postgres_database = var.postgres_database
  postgres_username = var.postgres_username
  dataset_id       = var.dataset_id
  name_prefix      = var.name_prefix

  # Optional configurations
  bigquery_location = "EU"
  replicate_tables  = ["users", "orders", "products"]
  data_freshness   = "15m"
  backfill_strategy = "all"
  
  labels = {
    environment = "example"
    managed_by  = "terraform"
  }
}
