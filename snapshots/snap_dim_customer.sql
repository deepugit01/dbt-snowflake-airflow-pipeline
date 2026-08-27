{% snapshot snap_dim_customer %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='dbt_loaded_at',
    )
}}

select * from {{ ref('stg_dim_customer') }}

{% endsnapshot %}