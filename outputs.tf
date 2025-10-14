# PostgreSQL to BigQuery outputs
output "datastream_stream_id" {
  description = "The ID of the Datastream stream"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].datastream_stream_id : null
}

output "datastream_stream_name" {
  description = "The full name of the Datastream stream"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].datastream_stream_name : null
}

output "bigquery_dataset_id" {
  description = "The BigQuery dataset ID"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].bigquery_dataset_id : null
}

output "postgres_connection_profile_id" {
  description = "The PostgreSQL connection profile ID"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].postgres_connection_profile_id : null
}

output "bigquery_connection_profile_id" {
  description = "The BigQuery connection profile ID"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].bigquery_connection_profile_id : null
}

output "datastream_user_name" {
  description = "The PostgreSQL user created for Datastream"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].datastream_user_name : null
}

output "datastream_user_password" {
  description = "The PostgreSQL user password for Datastream"
  value       = var.source_type == "postgresql" ? module.postgres_to_bigquery[0].datastream_user_password : null
  sensitive   = true
}
