{{
    config(
        materialized='incremental',
        unique_key='summary_key',
        incremental_strategy='merge'
    )
}}

with transactions as (
    select * from {{ ref('stg_fact_transactions') }}
    {% if is_incremental() %}
    where loaded_at > (select coalesce(max(loaded_at), '1900-01-01') from {{ this }})
    {% endif %}
),

customer_accounts as (
    select * from {{ ref('int_customer_accounts') }}
),

dates as (
    select * from {{ ref('stg_dim_date') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['t.txn_id']) }} as summary_key,
    t.txn_id,
    d.date_id,
    d.full_date,
    ca.branch_id,
    ca.branch_name,
    ca.customer_id,
    ca.customer_segment,
    t.txn_type,
    t.amount,
    t.txn_status,
    t.loaded_at
from transactions t
join customer_accounts ca on t.account_id = ca.account_id
left join dates d on to_number(to_char(t.txn_ts::date, 'YYYYMMDD')) = d.date_id