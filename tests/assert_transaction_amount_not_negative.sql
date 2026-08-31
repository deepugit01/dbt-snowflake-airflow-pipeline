select *
from {{ ref('stg_fact_transactions') }}
where amount < 0 AND txn_type != 'REFUND'