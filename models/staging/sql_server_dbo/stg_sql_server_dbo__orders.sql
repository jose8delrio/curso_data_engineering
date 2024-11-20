{{
  config(
    materialized='view'
  )
}}

with 

src_orders as (
    select * 
    from {{ source('sql_server_dbo', 'orders') }}
),

renamed as (
    select
        order_id,
        shipping_service,
        shipping_cost,
        address_id,
        created_at,
        case 
            when promo_id = '' then {{ no_promo_hash() }} -- Genera el hash para 'no_promo'
            else {{ dbt_utils.generate_surrogate_key(['promo_id']) }} -- Genera el hash normal
        end as promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced
    from src_orders
)

select * 
from renamed
