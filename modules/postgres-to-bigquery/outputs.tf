output "datastream_stream_id" {
  description = "The ID of the Datastream stream"
  value       = google_datastream_stream.postgres_to_bigquery.stream_id
}

output "datastream_stream_name" {
  description = "The full name of the Datastream stream"
  value       = google_datastream_stream.postgres_to_bigquery.name
}

output "bigquery_dataset_id" {
  description = "The BigQuery dataset ID"
  value       = google_bigquery_dataset.destination_dataset.dataset_id
}

output "postgres_connection_profile_id" {
  description = "The PostgreSQL connection profile ID"
  value       = google_datastream_connection_profile.postgres_source.connection_profile_id
}

output "bigquery_connection_profile_id" {
  description = "The BigQuery connection profile ID"
  value       = google_datastream_connection_profile.bigquery_destination.connection_profile_id
}

output "datastream_user_name" {
  description = "The PostgreSQL user created for Datastream"
  value       = var.postgres_instance_type == "cloudsql" ? google_sql_user.datastream_user_cloudsql[0].name : google_alloydb_user.datastream_user_alloydb[0].user_id
}

output "datastream_user_password" {
  description = "The PostgreSQL user password for Datastream"
  value       = random_password.datastream_user_password.result
  sensitive   = true
}