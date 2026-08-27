with source as (
    select * from {{ source('dbt_raw', 'transactions_raw') }}
),

flattened as (
    select
        raw_data:txn_id::int       as txn_id,
        raw_data:customer_id::int  as customer_id,
        raw_data:account_id::int   as account_id,
        raw_data:branch_id::int    as branch_id,
        raw_data:txn_type::string  as txn_type,
        raw_data:channel::string   as channel,
        raw_data:amount::number(12,2)        as amount,
        raw_data:balance_after::number(12,2) as balance_after,
        raw_data:currency::string  as currency,
        raw_data:merchant_category::string as merchant_category,
        raw_data:is_international::boolean as is_international,
        raw_data:txn_status::string as txn_status,

        coalesce(
            try_to_timestamp(raw_data:txn_ts::string, 'YYYY-MM-DD HH24:MI:SS'),
            try_to_timestamp(raw_data:txn_ts::string, 'DD-MON-YYYY HH24:MI:SS'),
            try_to_timestamp(raw_data:txn_ts::string, 'MM/DD/YYYY HH24:MI:SS'),
            try_to_timestamp(raw_data:txn_ts::string, 'DD/MM/YYYY HH24:MI:SS')
        ) as txn_ts,

        loaded_at,
        current_timestamp() as dbt_loaded_at
    from source
),

deduplicated as (
    select *
    from flattened
    qualify row_number() over (
        partition by txn_id
        order by loaded_at desc
    ) = 1
)

select * from deduplicated
where txn_id is not null