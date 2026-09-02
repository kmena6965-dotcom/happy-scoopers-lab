-- models/marts/dim_date.sql
{{ config(materialized='table') }}

with fechas as (
    select generate_series(
        '2020-01-01'::date,
        '2030-12-31'::date,
        '1 day'::interval
    )::date as full_date
),

calendario as (
    select
        extract(year from full_date)::int * 10000 
        + extract(month from full_date)::int * 100 
        + extract(day from full_date)::int as date_key,
        full_date,
        extract(year from full_date)::int as year_number,
        extract(quarter from full_date)::int as quarter_number,
        'Q' || extract(quarter from full_date)::int as quarter_name,
        extract(month from full_date)::int as month_number,
        trim(to_char(full_date, 'Month')) as month_name,
        trim(to_char(full_date, 'Mon')) as month_name_short,
        extract(day from full_date)::int as day_of_month,
        extract(isodow from full_date)::int as day_of_week,
        trim(to_char(full_date, 'Day')) as day_name,
        extract(week from full_date)::int as week_of_year,
        to_char(full_date, 'YYYY-MM') as year_month,
        case when extract(isodow from full_date) in (6,7) 
            then 'Fin de semana' else 'Entre semana' end as day_type
    from fechas
),

-- Fila "desconocida" para hechos que no tengan una fecha válida (usar date_key = -1)
unknown_member as (
    select
        -1 as date_key, null::date as full_date, null::int as year_number,
        null::int as quarter_number, 'N/A' as quarter_name, null::int as month_number,
        'N/A' as month_name, 'N/A' as month_name_short, null::int as day_of_month,
        null::int as day_of_week, 'N/A' as day_name, null::int as week_of_year,
        'N/A' as year_month, 'N/A' as day_type
)

select * from calendario
union all
select * from unknown_member