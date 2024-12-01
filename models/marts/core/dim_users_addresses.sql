{{
  config(
    materialized='table'
  )
}}


with users as (
    select *
    from {{ ref('stg_sql_server_dbo__users') }}
),

addresses as (
    select *
    from {{ ref('stg_sql_server_dbo__addresses') }}
),

countries as (
    select *
    from {{ ref("base_sql_server_dbo__countries") }}
)

select
    u.user_id,
    u.address_id,
    c.country_id,
    u.first_name,
    u.last_name,
    u.phone_number,
    ad.address,
    ad.state,
    c.country_name,
    ad.zipcode
from users u   
left join addresses ad
    on u.address_id = ad.address_id
left join countries c
    on ad.country_id = c.country_id