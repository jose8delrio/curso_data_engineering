{{
  config(
    materialized='table'
  )
}}

WITH base_orders AS (
    SELECT
        o.order_id,
        o.user_id,
        o.address_id,
        o.promo_id,
        o.order_status,
        t.shipping_service, -- Información traída desde la tabla tracking
        o.tracking_id,
        o.estimated_delivery_at
    FROM {{ ref('stg_sql_server_dbo__orders') }} o
    LEFT JOIN {{ ref('stg_sql_server_dbo__tracking') }} t
      ON o.tracking_id = t.tracking_id
)
SELECT
    order_id,
    user_id,
    address_id,
    promo_id,
    tracking_id,
    shipping_service,
    order_status,
    estimated_delivery_at
FROM base_orders
