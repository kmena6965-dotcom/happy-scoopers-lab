with source as ( select * from {{ source('raw', 'payment_types') }})
select
    payment_type_id,
    payment_type_name
from source