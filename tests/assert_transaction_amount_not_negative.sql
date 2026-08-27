select *
from {{ ref('stg_fact_transactions') }}
where amount < 0