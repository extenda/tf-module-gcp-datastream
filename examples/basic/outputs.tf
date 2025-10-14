output "datastream_stream_id" {
  description = "The ID of the created Datastream stream"
  value       = module.datastream_replication.datastream_stream_id
}

output "bigquery_dataset_id" {
  description = "The BigQuery dataset ID"
  value       = module.datastream_replication.bigquery_dataset_id
}

output "postgres_connection_profile_id" {
  description = "The PostgreSQL connection profile ID"
  value       = module.datastream_replication.postgres_connection_profile_id
}

output "bigquery_connection_profile_id" {
  description = "The BigQuery connection profile ID"
  value       = module.datastream_replication.bigquery_connection_profile_id
}