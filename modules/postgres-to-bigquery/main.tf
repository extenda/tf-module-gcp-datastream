# Naming convention locals
locals {
  # Default naming convention - follows your infrastructure patterns
  # Examples: "nyce-logic-datastream-postgres", "nyce-logic-datastream-bigquery", "nyce-logic-datastream-stream"
  default_postgres_profile_id  = "${var.name_prefix}-datastream-postgres"
  default_bigquery_profile_id  = "${var.name_prefix}-datastream-bigquery"
  default_stream_id            = "${var.name_prefix}-datastream-stream"
  default_postgres_publication = "${replace(var.name_prefix, "-", "_")}_publication"
  default_postgres_replication_slot = "${replace(var.name_prefix, "-", "_")}_replication_slot"
  
  # Use custom names if provided, otherwise use defaults
  postgres_profile_id     = var.postgres_connection_profile_id != null ? var.postgres_connection_profile_id : local.default_postgres_profile_id
  bigquery_profile_id     = var.bigquery_connection_profile_id != null ? var.bigquery_connection_profile_id : local.default_bigquery_profile_id
  stream_id              = var.stream_id != null ? var.stream_id : local.default_stream_id
  postgres_publication   = var.postgres_publication != null ? var.postgres_publication : local.default_postgres_publication
  postgres_replication_slot = var.postgres_replication_slot != null ? var.postgres_replication_slot : local.default_postgres_replication_slot
}

# Generate a random password for the Datastream user
resource "random_password" "datastream_user_password" {
  length  = 16
  special = true
}

# Create a dedicated user for Datastream - Cloud SQL
resource "google_sql_user" "datastream_user_cloudsql" {
  count    = var.postgres_instance_type == "cloudsql" ? 1 : 0
  name     = var.postgres_username
  instance = var.postgres_instance
  password = random_password.datastream_user_password.result
}

# Create a dedicated user for Datastream - AlloyDB
resource "google_alloydb_user" "datastream_user_alloydb" {
  count       = var.postgres_instance_type == "alloydb" ? 1 : 0
  user_id     = var.postgres_username
  cluster     = var.postgres_instance
  user_type   = "ALLOYDB_BUILT_IN"
  password    = random_password.datastream_user_password.result
}

# Create BigQuery dataset for the replicated data
resource "google_bigquery_dataset" "destination_dataset" {
  dataset_id  = var.dataset_id
  location    = var.bigquery_location
  description = "Dataset for Datastream replication from PostgreSQL"

  labels = var.labels

  # Optional: Set table expiration
  default_table_expiration_ms = null

  # Keep deletion protection enabled (match existing dataset)
  delete_contents_on_destroy = false
}

# Get the BigQuery service account for KMS permissions
data "google_bigquery_default_service_account" "bq_service_account" {
  project = var.project_id
}

# Get project information to access project number
data "google_project" "current" {
  project_id = var.project_id
}

# Source connection profile for PostgreSQL
resource "google_datastream_connection_profile" "postgres_source" {
  display_name          = local.postgres_profile_id
  location              = var.region
  connection_profile_id = local.postgres_profile_id

  postgresql_profile {
    hostname = var.postgres_host
    port     = 5432
    username = var.postgres_username
    password = random_password.datastream_user_password.result
    database = var.postgres_database
  }

  labels = var.labels
}

# Destination connection profile for BigQuery
resource "google_datastream_connection_profile" "bigquery_destination" {
  display_name          = local.bigquery_profile_id
  location              = var.region
  connection_profile_id = local.bigquery_profile_id

  bigquery_profile {}

  labels = var.labels
}

# The Datastream stream
resource "google_datastream_stream" "postgres_to_bigquery" {
  stream_id    = local.stream_id
  location     = var.region
  display_name = local.stream_id
  
  # Stream validation setting - configurable for different environments
  create_without_validation = var.create_without_validation
  
  # Desired state - automatically start the stream
  desired_state = var.desired_state
  
  labels = var.labels

  source_config {
    source_connection_profile = "projects/${data.google_project.current.number}/locations/${var.region}/connectionProfiles/${local.postgres_profile_id}"
    
    postgresql_source_config {
      # Required replication slot and publication names
      replication_slot = local.postgres_replication_slot
      publication      = local.postgres_publication
      
      # Maximum concurrent backfill tasks (configurable)
      max_concurrent_backfill_tasks = var.max_concurrent_backfill_tasks
      
      # Configure table replication based on user input
      dynamic "include_objects" {
        for_each = var.replicate_schemas
        content {
          postgresql_schemas {
            schema = include_objects.value
            dynamic "postgresql_tables" {
              for_each = var.replicate_tables == "all" ? ["*"] : var.replicate_tables
              content {
                table = postgresql_tables.value
              }
            }
          }
        }
      }
      
      # Match existing stream - no exclude_objects (existing has excludeObjects: {})
    }
  }

  destination_config {
    destination_connection_profile = "projects/${data.google_project.current.number}/locations/${var.region}/connectionProfiles/${local.bigquery_profile_id}"
    
    bigquery_destination_config {
      # Use single target dataset to match existing configuration
      single_target_dataset {
        dataset_id = "${var.project_id}:${var.dataset_id}"
      }
      
      # Add merge block to match existing stream
      merge {}
      
      # Data freshness - how often to commit data to BigQuery
      data_freshness = var.data_freshness == "15m" ? "900s" : var.data_freshness == "5m" ? "300s" : var.data_freshness == "1h" ? "3600s" : var.data_freshness
    }
  }

  # Backfill strategy based on configuration
  dynamic "backfill_all" {
    for_each = var.backfill_strategy == "all" ? [1] : []
    content {}
  }
  
  dynamic "backfill_none" {
    for_each = var.backfill_strategy == "none" ? [1] : []
    content {}
  }

  depends_on = [
    google_sql_user.datastream_user_cloudsql,
    google_alloydb_user.datastream_user_alloydb,
    google_bigquery_dataset.destination_dataset
  ]
}