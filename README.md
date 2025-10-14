# Google Cloud Datastream PostgreSQL to BigQuery Module

This Terraform module creates a complete Google Cloud Datastream setup to replicate data from a PostgreSQL Cloud SQL instance to BigQuery.

## Features

- ✅ **Flexible naming convention** with sensible defaults
- ✅ **Custom name overrides** for importing existing resources
- ✅ **PostgreSQL user management** with auto-generated secure passwords
- ✅ **BigQuery dataset creation** with configurable location
- ✅ **Selective table replication** (all tables or specific tables)
- ✅ **Configurable data freshness** (5m, 15m, 1h)
- ✅ **Backfill strategies** (all historical data or ongoing changes only)
- ✅ **Comprehensive labeling** support
- ✅ **Public/Private IP** support for PostgreSQL connections

## Architecture

This module follows a modular architecture:

- **Main Module**: Orchestrates the creation of resources based on source type
- **Sub-modules**: Source-specific implementations under `modules/`
  - `postgres-to-bigquery`: Handles PostgreSQL to BigQuery replication

This structure allows for future expansion to support additional source types (e.g., MySQL, SQL Server) while maintaining a consistent interface.

## Usage

### Basic Usage

```hcl
module "datastream" {
  source = "git@github.com:extenda/tf-module-gcp-datastream.git?ref=v1.0.0"

  # Source type (currently only postgresql supported)
  source_type = "postgresql"

  # Required variables
  project_id        = "my-project-id"
  region           = "europe-west1"
  postgres_host    = "10.1.2.3"
  postgres_instance = "my-postgres-instance"
  postgres_database = "my-database"
  postgres_username = "datastream_user"
  dataset_id       = "my_dataset"
  name_prefix      = "my-app"

  # Optional variables
  bigquery_location = "EU"
  replicate_tables  = ["users", "orders"]
  data_freshness   = "15m"
  backfill_strategy = "all"
  
  labels = {
    environment = "production"
    team       = "data"
  }
}
```

### Advanced Usage with Custom Names

```hcl
module "datastream" {
  source = "git@github.com:extenda/tf-module-gcp-datastream.git?ref=v1.0.0"

  # Required variables
  project_id        = "my-project-id"
  region           = "europe-west1"
  postgres_host    = "34.77.161.254"  # Public IP
  postgres_instance = "my-postgres-instance"
  postgres_database = "production_db"
  postgres_username = "datastream"
  dataset_id       = "raw_replication"
  name_prefix      = "prod-app"

  # Custom resource names (useful for importing existing resources)
  postgres_connection_profile_id = "existing-postgres-profile"
  bigquery_connection_profile_id = "existing-bq-profile"
  stream_id                      = "existing-stream"
  
  # Custom PostgreSQL objects (for existing setups)
  postgres_publication       = "custom_publication"
  postgres_replication_slot  = "custom_slot"

  # Replicate all tables
  replicate_tables = "all"
  
  # High frequency replication
  data_freshness = "5m"
  
  # No historical backfill
  backfill_strategy = "none"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID | `string` | n/a | yes |
| region | The region for Datastream resources | `string` | n/a | yes |
| postgres_host | PostgreSQL instance IP address (public or private) | `string` | n/a | yes |
| postgres_instance | PostgreSQL instance name | `string` | n/a | yes |
| postgres_database | PostgreSQL database name | `string` | n/a | yes |
| postgres_username | PostgreSQL username for Datastream | `string` | n/a | yes |
| dataset_id | BigQuery dataset ID | `string` | n/a | yes |
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| bigquery_location | BigQuery dataset location | `string` | `"EU"` | no |
| labels | Labels to apply to resources | `map(string)` | `{}` | no |
| replicate_tables | Tables to replicate - 'all' for all tables or list of specific tables | `any` | `"all"` | no |
| replicate_schemas | List of schemas to replicate from | `list(string)` | `["public"]` | no |
| data_freshness | How often to commit data to BigQuery (5m, 15m, 1h) | `string` | `"15m"` | no |
| backfill_strategy | Backfill strategy: 'all' or 'none' | `string` | `"all"` | no |
| postgres_connection_profile_id | Custom PostgreSQL connection profile ID | `string` | `null` | no |
| bigquery_connection_profile_id | Custom BigQuery connection profile ID | `string` | `null` | no |
| stream_id | Custom Datastream stream ID | `string` | `null` | no |
| postgres_publication | PostgreSQL publication name | `string` | `null` | no |
| postgres_replication_slot | PostgreSQL replication slot name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| datastream_stream_id | The ID of the Datastream stream |
| datastream_stream_name | The full name of the Datastream stream |
| bigquery_dataset_id | The BigQuery dataset ID |
| postgres_connection_profile_id | The PostgreSQL connection profile ID |
| bigquery_connection_profile_id | The BigQuery connection profile ID |
| datastream_user_name | The PostgreSQL user created for Datastream |
| datastream_user_password | The PostgreSQL user password for Datastream (sensitive) |

## Naming Convention

By default, the module uses the following naming convention:

- **PostgreSQL Connection Profile**: `{name_prefix}-datastream-postgres`
- **BigQuery Connection Profile**: `{name_prefix}-datastream-bigquery`  
- **Datastream Stream**: `{name_prefix}-datastream-stream`
- **PostgreSQL Publication**: `{name_prefix}_publication` (underscores for PostgreSQL compatibility)
- **PostgreSQL Replication Slot**: `{name_prefix}_replication_slot`

### Examples:
With `name_prefix = "nyce-logic"`:
- PostgreSQL Profile: `nyce-logic-datastream-postgres`
- BigQuery Profile: `nyce-logic-datastream-bigquery`
- Stream: `nyce-logic-datastream-stream`
- Publication: `nyce_logic_publication`
- Replication Slot: `nyce_logic_replication_slot`

## Prerequisites

1. **PostgreSQL Instance**: Cloud SQL PostgreSQL instance with logical decoding enabled
2. **Network Access**: Datastream IP ranges added to PostgreSQL authorized networks
3. **Permissions**: Service account with required IAM roles:
   - `roles/datastream.admin`
   - `roles/bigquery.dataEditor`
   - `roles/bigquery.jobUser`
   - `roles/cloudsql.client`

## Important Notes

- The module creates a dedicated PostgreSQL user for Datastream with a random password
- BigQuery dataset will be created if it doesn't exist
- For existing setups, use custom name variables to match existing resources
- Use `terraform import` to bring existing resources under Terraform management

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 4.84.0 |
| random | >= 3.1 |

## License

This module is maintained by Extenda Retail.