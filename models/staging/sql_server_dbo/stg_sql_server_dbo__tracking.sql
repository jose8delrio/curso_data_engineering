{{
  config(
    materialized='view'
  )
}}

with src_orders as(
    select
        case
            when tracking_id = '' or tracking_id is null then md5('no_tracking')
            else tracking_id
        end as tracking_id,
        coalesce(nullif(trim(shipping_service), ''), 'not_assigned_yet') as shipping_service
    from {{ source('sql_server_dbo','orders') }}
)

select DISTINCT * from src_orders