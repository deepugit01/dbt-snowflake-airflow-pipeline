with source as (
    select * from {{ source('dbt_raw', 'customers_raw') }}
),

flattened as (
    select
        raw_data:customer_id::int as customer_id,
        raw_data:name::string     as customer_name,
        raw_data:email::string    as email,

        {{ safe_cast_date("raw_data:dob::string") }} as dob,

        raw_data:pan_number::string as pan_number,
        raw_data:segment::string    as customer_segment,
        raw_data:kyc_status::string as kyc_status,
        raw_data:country::string    as country,

        loaded_at,
        current_timestamp() as dbt_loaded_at
    from source
),

deduplicated as (
    select *
    from flattened
    qualify row_number() over (
        partition by customer_id
        order by loaded_at desc
    ) = 1
)

select * from deduplicated
where customer_id is not null