{{
  config(
    materialized='view'
  )
}}

with src_orders as(
    select 
        tracking_id,
        shipping_service
    from {{ source('sql_server_dbo','orders') }}
    where tracking_id != '' and shipping_service != ''
)

select * from src_orders