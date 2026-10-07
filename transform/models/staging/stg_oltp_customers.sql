with source as ( select * from {{ source('raw', 'customers') }} )
select
    customer_id, first_name, last_name, full_name, title,
    delivery_address_id, billing_address_id, phone_number, email
from source