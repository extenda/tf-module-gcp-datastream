# Source type selection
variable "source_type" {
  description = "The source database type for Datastream replication"
  type        = string
  default     = "postgresql"
  
  validation {
    condition     = contains(["postgresql"], var.source_type)
    error_message = "Currently only 'postgresql' is supported. Future versions will support mysql, oracle, etc."
  }
}

# Required variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for Datastream resources"
  type        = string
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
}

variable "postgres_username" {
  description = "PostgreSQL username for Datastream"
  type        = string
}

variable "dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

# Optional variables with defaults
variable "bigquery_location" {
  description = "BigQuery dataset location"
  type        = string
  default     = "EU"
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "replicate_tables" {
  description = "Tables to replicate - 'all' for all tables or list of specific tables"
  type        = any
  default     = "all"
}

variable "replicate_schemas" {
  description = "List of schemas to replicate from"
  type        = list(string)
  default     = ["public"]
}

variable "data_freshness" {
  description = "How often to commit data to BigQuery (e.g., '15m', '5m', '1h')"
  type        = string
  default     = "15m"
}

variable "backfill_strategy" {
  description = "Backfill strategy: 'all' or 'none'"
  type        = string
  default     = "all"
  
  validation {
    condition     = contains(["all", "none"], var.backfill_strategy)
    error_message = "Backfill strategy must be either 'all' or 'none'."
  }
}

# Custom naming variables (optional)
variable "postgres_connection_profile_id" {
  description = "Custom PostgreSQL connection profile ID. If null, uses '{name_prefix}-datastream-postgres'"
  type        = string
  default     = null
}

variable "bigquery_connection_profile_id" {
  description = "Custom BigQuery connection profile ID. If null, uses '{name_prefix}-datastream-bigquery'"
  type        = string
  default     = null
}

variable "stream_id" {
  description = "Custom Datastream stream ID. If null, uses '{name_prefix}-datastream-stream'"
  type        = string
  default     = null
}

variable "postgres_publication" {
  description = "PostgreSQL publication name. If null, uses '{name_prefix}_publication'"
  type        = string
  default     = null
}

variable "postgres_replication_slot" {
  description = "PostgreSQL replication slot name. If null, uses '{name_prefix}_replication_slot'"
  type        = string
  default     = null
}
