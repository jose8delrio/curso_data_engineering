{{
  config(
    materialized='view'
  )
}}

with 

src_users as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id,
        address_id,
        last_name,
        first_name,
        coalesce(total_orders,0) as total_orders,
        phone_number,
        coalesce (regexp_like(phone_number, '^(\([0-9]{3}\)|[0-9]{3}-)[0-9]{3}-[0-9]{4}$')= true,false) as is_valid_phone_number,
        email,
        coalesce (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address,
        convert_timezone('UTC', updated_at) as user_updated_at,
        convert_timezone('UTC', created_at) as user_created_at,
        coalesce(_fivetran_deleted, FALSE) AS user_date_deleted,
        convert_timezone('UTC', _fivetran_synced) AS user_date_load

    from src_users

)

select * from renamed
