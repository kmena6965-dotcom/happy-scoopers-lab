with source as (
    select * from {{ source('raw', 'promotions') }}
)

select 
    promotion_id,
    deal_description,
    start_date,
    end_date,
    discount_amount,
    discount_percentage
from source