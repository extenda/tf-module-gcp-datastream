locals {
  # Determine which source type to use (for future extensibility)
  source_type = var.source_type
}

# PostgreSQL to BigQuery Datastream
module "postgres_to_bigquery" {
  count = var.source_type == "postgresql" ? 1 : 0
  
  source = "./modules/postgres-to-bigquery"

  # Required variables
  project_id        = var.project_id
  region           = var.region
  postgres_host    = var.postgres_host
  postgres_instance = var.postgres_instance
  postgres_instance_type = var.postgres_instance_type
  postgres_database = var.postgres_database
  postgres_username = var.postgres_username
  dataset_id       = var.dataset_id
  name_prefix      = var.name_prefix

  # Optional variables
  bigquery_location = var.bigquery_location
  labels           = var.labels
  replicate_tables = var.replicate_tables
  replicate_schemas = var.replicate_schemas
  data_freshness   = var.data_freshness
  backfill_strategy = var.backfill_strategy

  # Custom naming variables
  postgres_connection_profile_id = var.postgres_connection_profile_id
  bigquery_connection_profile_id = var.bigquery_connection_profile_id
  stream_id                      = var.stream_id
  postgres_publication           = var.postgres_publication
  postgres_replication_slot      = var.postgres_replication_slot
  
  # Performance tuning
  max_concurrent_backfill_tasks  = var.max_concurrent_backfill_tasks
  create_without_validation      = var.create_without_validation
  desired_state                  = var.desired_state
}
