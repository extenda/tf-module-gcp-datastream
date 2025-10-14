variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for Datastream resources"
  type        = string
  default     = "europe-west1"
}

variable "postgres_host" {
  description = "PostgreSQL instance IP address"
  type        = string
}

variable "postgres_instance" {
  description = "PostgreSQL instance name"
  type        = string
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
  default     = "postgres"
}

variable "postgres_username" {
  description = "PostgreSQL username for Datastream"
  type        = string
  default     = "datastream_user"
}

variable "dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
  default     = "datastream_replication"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "example-app"
}