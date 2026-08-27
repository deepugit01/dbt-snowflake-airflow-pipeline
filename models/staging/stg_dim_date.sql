with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2024-01-01' as date)",
        end_date="cast('2027-12-31' as date)"
    ) }}
),

final as (
    select
        to_number(to_char(date_day, 'YYYYMMDD')) as date_id,
        date_day as full_date,
        year(date_day) as year,
        quarter(date_day) as quarter,
        month(date_day) as month,
        monthname(date_day) as month_name,
        dayname(date_day) as day_name,
        dayofweek(date_day) as day_of_week,
        dayofweek(date_day) in (0, 6) as is_weekend
    from date_spine
)

select * from final