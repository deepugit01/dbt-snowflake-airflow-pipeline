# dbt-snowflake-airflow-pipeline

# dbt + Snowflake + Airflow — Production-Grade Pipeline

A real-time-style analytics pipeline: Snowpipe ingests JSON data into Snowflake,
dbt transforms it through a staging → intermediate → marts architecture, and
Airflow orchestrates scheduled runs.

## Features demonstrated
- Sources with freshness checks
- Staging models (JSON flattening)
- Ephemeral intermediate models
- Incremental materializations (merge strategy)
- Snapshots (SCD Type 2)
- Seeds, macros, generic + singular + unit tests
- dbt contracts, tags, exposures
- Airflow DAG orchestrating scheduled dbt runs

## Architecture
Snowpipe (S3 → Snowflake) → dbt (staging → intermediate → marts) → Airflow (orchestration)
