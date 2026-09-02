-- models/marts/dim_date.sql
{{ config(materialized='table') }}

with fechas as (
    select generate_series(
        '2020-01-01'::date,
        '2030-12-31'::date,
        '1 day'::interval
    )::date as full_date
)

select
    -- Llave única en formato YYYYMMDD (ej. 20250115)
    extract(year from full_date)::int * 10000
    + extract(month from full_date)::int * 100
    + extract(day from full_date)::int as date_key,
    full_date
from fechas
