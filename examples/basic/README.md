# Basic Datastream PostgreSQL to BigQuery Example

This example demonstrates the basic usage of the Datastream module.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Configuration

This example creates:
- A Datastream connection from PostgreSQL to BigQuery
- Replication of specific tables from the public schema
- BigQuery dataset in the EU region
- 15-minute data freshness

## Variables

You can customize the example by setting these variables:

```bash
export TF_VAR_project_id="your-project-id"
export TF_VAR_postgres_host="10.1.2.3"
export TF_VAR_postgres_instance="your-postgres-instance"
```