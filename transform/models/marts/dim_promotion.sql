{{ config(materialized='table') }}

with p as (
    select * from {{ ref('stg_oltp_promotions') }}
),

final as (
    select 
        {{ dbt_utils.generate_surrogate_key(['promotion_id']) }} as promotion_key, 
        *
    from p
),

unknown_member as (
    select 
        '-1' as promotion_key, 
        -1 as promotion_id, 
        'N/A' as deal_description,
        null::date as start_date, 
        null::date as end_date,
        null::numeric as discount_amount, 
        null::numeric as discount_percentage
)

select * from final
union all
select * from unknown_member