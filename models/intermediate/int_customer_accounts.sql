{{ config(materialized='ephemeral') }}

with accounts as (
    select * from {{ ref('stg_dim_account') }}
),

customers as (
    select * from {{ ref('stg_dim_customer') }}
),

branches as (
    select * from {{ ref('stg_dim_branch') }}
)

select
    a.account_id,
    a.account_type,
    a.opened_date,
    a.account_status,
    c.customer_id,
    c.customer_name,
    c.customer_segment,
    c.kyc_status,
    c.country,
    b.branch_id,
    b.branch_name,
    b.region
from accounts a
join customers c on a.customer_id = c.customer_id
join branches b on a.branch_id = b.branch_id