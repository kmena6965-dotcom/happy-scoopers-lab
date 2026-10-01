{{ config(materialized='table') }}

with adr as ( select * from {{ ref('stg_oltp__addresses') }} ),
cit as ( select * from {{ ref('stg_oltp__cities') }} ),
prv as ( select * from {{ ref('stg_oltp__provinces') }} ),
cou as ( select * from {{ ref('stg_oltp__countries') }} ),

joined as (
    select
        adr.address_id,
        coalesce(cou.continent, 'N/A')     as continent,
        coalesce(cou.region, 'N/A')        as region,
        coalesce(cou.subregion, 'N/A')     as subregion,
        coalesce(cou.country_code, 'N/A')  as country_code,
        coalesce(cou.country_name, 'N/A')  as country,
        coalesce(cou.formal_name, 'N/A')   as country_formal_name,
        cou.population                     as country_population,
        coalesce(prv.province_code, 'N/A') as province_code,
        coalesce(prv.province_name, 'N/A') as province,
        prv.population                     as province_population,
        coalesce(cit.city_name, 'N/A')     as city,
        cit.population                     as city_population,
        coalesce(adr.address_line1, 'N/A') as address_line1,
        coalesce(adr.address_line2, 'N/A') as address_line2,
        coalesce(adr.postal_code, 'N/A')   as postal_code
    from adr
    left join cit on adr.city_id = cit.city_id
    left join prv on cit.province_id = prv.province_id
    left join cou on prv.country_id = cou.country_id
),

final as (
    select {{ dbt_utils.generate_surrogate_key(['address_id']) }} as location_key, * from joined
),

unknown_member as (
    select
        '-1' as location_key, -1 as address_id,
        'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', null::bigint,
        'N/A', 'N/A', null::bigint, 'N/A', null::bigint, 'N/A', 'N/A', 'N/A'
)

select * from final
union all
select * from unknown_member