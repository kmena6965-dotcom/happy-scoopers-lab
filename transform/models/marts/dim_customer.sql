{{ config(materialized='table') }}

with c     as ( select * from {{ ref('stg_oltp_customers') }} ),
    loc as ( select address_id, location_key from {{ ref('dim_location') }} ),

joined as (
    select
        c.customer_id, c.first_name, c.last_name, c.full_name, c.title,
        c.phone_number, coalesce(c.email, 'N/A') as email,
        coalesce(dloc.location_key, '-1') as delivery_location_key,
        coalesce(bloc.location_key, '-1') as billing_location_key
    from c
    left join loc dloc on c.delivery_address_id = dloc.address_id
    left join loc bloc on c.billing_address_id = bloc.address_id
),

final as (
    select {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key, * from joined
),

unknown_member as (
    select '-1' as customer_key, -1 as customer_id, 'Desconocido','N/A','N/A','N/A','N/A','N/A','N/A','-1','-1'
)

select * from final
union all
select * from unknown_member