{{ config(materialized='table') }}

with orders as (
    select
        order_id,
        address_id,
        promo_id,
        user_id,
        shipping_service,
        order_status,
        order_created_at,
        estimated_delivery_at,
        delivered_at
    from {{ ref('stg_sql_server_dbo__orders') }} o
    LEFT JOIN {{ref('stg_sql_server_dbo__tracking')}} t 
        ON t.tracking_id=o.tracking_id
),

order_items_bridge as (
    select
        order_id, -- Clave puente para conectar órdenes e ítems
        product_id,
        quantity_product
    from {{ ref('stg_sql_server_dbo__order_items') }}
),

order_items as (
    select
        {{ dbt_utils.generate_surrogate_key(['bridge.order_id', 'p.product_id']) }} as order_item_id, -- Clave única por orden y producto
        bridge.order_id,
        bridge.product_id,
        bridge.quantity_product,
        (bridge.quantity_product * p.product_price) as product_total_cost
    from order_items_bridge bridge
    left join {{ ref('stg_sql_server_dbo__products') }} p
        on bridge.product_id = p.product_id
),

combined as (
    select
        o.order_id,
        oi.order_item_id,
        o.promo_id,
        o.address_id,
        o.user_id,
        o.shipping_service,
        o.order_status,
        order_created_at,
        estimated_delivery_at,
        delivered_at
    from orders o
    left join order_items oi
        on o.order_id = oi.order_id
)

select * from combined