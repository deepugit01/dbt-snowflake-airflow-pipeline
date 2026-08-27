with source as (
    select * from {{ source('dbt_raw', 'accounts_raw') }}
),

flattened as (
    select
        raw_data:account_id::int  as account_id,
        raw_data:customer_id::int as customer_id,
        raw_data:account_type::string as account_type,

        coalesce(
            try_to_date(raw_data:opened_date::string, 'YYYY-MM-DD'),
            try_to_date(raw_data:opened_date::string, 'DD/MM/YYYY'),
            try_to_date(raw_data:opened_date::string, 'MM-DD-YYYY'),
            try_to_date(raw_data:opened_date::string, 'DD-MON-YYYY'),
            try_to_date(raw_data:opened_date::string, 'YYYYMMDD')
        ) as opened_date,

        raw_data:status::string    as account_status,
        raw_data:branch_id::int    as branch_id,

        loaded_at,
        current_timestamp() as dbt_loaded_at
    from source
),

deduplicated as (
    select *
    from flattened
    qualify row_number() over (
        partition by account_id
        order by loaded_at desc
    ) = 1
)

select * from deduplicated
where account_id is not null