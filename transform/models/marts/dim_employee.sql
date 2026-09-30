select
    e.employee_id,
    e.first_name || ' ' || e.last_name      as empleado,
    e.job_title,
    cit.city_name                           as city,
    cou.country_name                        as country,
    jefe.first_name || ' ' || jefe.last_name as manager_name  -- ¡la misma tabla!
from raw.employees e
left join raw.addresses  adr on e.address_id   = adr.address_id
left join raw.cities     cit on adr.city_id    = cit.city_id
left join raw.provinces  prv on cit.province_id = prv.province_id
left join raw.countries  cou on prv.country_id = cou.country_id
left join raw.employees jefe on e.manager_id   = jefe.employee_id  -- self-join
select * from final