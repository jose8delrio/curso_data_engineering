{{
  config(
    materialized='table'
  )
}}


with 

base_users as (

    select * from {{ ref('base_sql_server_dbo__users') }}

),

source_orders as (
    select user_id, count(*) as total_orders 
        from {{ source('sql_server_dbo', 'orders') }} 
    group by user_id
),

renamed_users as (

    select
        A.user_id,
        address_id,
        last_name,
        first_name,
        case
            when B.total_orders is null then 0
            else B.total_orders
        end as total_orders,
        phone_number,
        is_valid_phone_number,
        email,
        is_valid_email_address,
        user_updated_at,
        user_created_at,
        user_date_deleted,
        user_date_load

    from base_users A
    left join source_orders B
    on A.user_id=B.user_id

)

select * from renamed_users