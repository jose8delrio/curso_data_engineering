{{
  config(
    materialized='table'
  )
}}

with source as (
    select *
    from {{source('sql_server_dbo','orders')}}
),

renamed_orders as (
    select
        order_id,
        address_id,
        case 
            when promo_id !='' then {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
            else  md5('no_promo')
        end as promo_id,
        user_id,
        case
            when tracking_id = '' or tracking_id is null then md5('no_tracking')
            else tracking_id
        end as tracking_id,
        order_cost,
        shipping_cost,
        order_total,
        status as order_status,
        convert_timezone('UTC', created_at) as order_created_at,
        convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at,
        convert_timezone('UTC', delivered_at) as delivered_at,
        coalesce(_fivetran_deleted, FALSE) AS orders_date_deleted,
        convert_timezone('UTC', _fivetran_synced) as orders_date_load
    from source
)

select * from renamed_orders