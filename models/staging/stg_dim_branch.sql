with source as (
    select * from {{ source('dbt_raw', 'branches_raw') }}
),

flattened as (
    select
        raw_data:branch_id::int    as branch_id,
        raw_data:branch_name::string as branch_name,
        raw_data:city::string      as city,
        raw_data:region::string    as region,

        loaded_at,
        current_timestamp() as dbt_loaded_at
    from source
),

deduplicated as (
    select *
    from flattened
    qualify row_number() over (
        partition by branch_id
        order by loaded_at desc
    ) = 1
)

select * from deduplicated
where branch_id is not null