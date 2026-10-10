{{ config(materialized='table') }}

with pt as (select * from {{ ref('stg_oltp_payment_types') }}),

final as (
    select{{ dbt_utils.generate_surrogate_key(['payment_type_id']) }} as payment_type_key,
  *from pt
),

unknown_member as (
    select '-1' as payment_type_key, -1 as payment_type_id, 'N/A' as payment_type_name
)

select * from final
union all
select * from unknown_member