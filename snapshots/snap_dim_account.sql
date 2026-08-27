{% snapshot snap_dim_account %}

{{
    config(
        target_schema='snapshots',
        unique_key='account_id',
        strategy='timestamp',
        updated_at='dbt_loaded_at',
    )
}}

select * from {{ ref('stg_dim_account') }}

{% endsnapshot %}