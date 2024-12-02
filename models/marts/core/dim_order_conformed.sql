{{
  config(
    materialized='table'
  )
}}

with product_de_order_items as (
    select
        oi.product_id
    from {{ ref("stg_sql_server_dbo__products") }} p
    left join {{ ref('stg_sql_server_dbo__order_items') }} oi
        on p.product_id = oi.product_id
),

base_orders AS (
    SELECT
        o.order_id,
        o.user_id,
        {{ dbt_utils.generate_surrogate_key(['o.order_id', 'oi.product_id']) }} as order_item_id,  -- Generación de la clave surrogada
        o.address_id,
        o.promo_id,
        o.order_status,
        t.shipping_service,  -- Información de la tabla tracking
        o.tracking_id,
        o.estimated_delivery_at
    FROM {{ ref('stg_sql_server_dbo__orders') }} o
    LEFT JOIN {{ ref('stg_sql_server_dbo__tracking') }} t
      ON o.tracking_id = t.tracking_id
    LEFT JOIN {{ ref('stg_sql_server_dbo__order_items') }} oi  -- Relacionamos orders con order_items
      ON o.order_id = oi.order_id  -- Ahora unimos por order_id, no product_id
    LEFT JOIN {{ ref('stg_sql_server_dbo__products') }} p
      ON p.product_id = oi.product_id  -- Relacionamos products con order_items
)
SELECT
    order_item_id,
    order_id,
    {{ dbt_utils.generate_surrogate_key(['user_id', 'address_id']) }} as user_address_id,
    promo_id,
    shipping_service,
    order_status,
    estimated_delivery_at
FROM base_orders
