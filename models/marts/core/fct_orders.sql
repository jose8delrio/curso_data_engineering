{{
  config(
    materialized='table'
  )
}}

WITH base_orders AS (
    SELECT
        order_id,
        shipping_cost,
        order_cost,
        order_total,
        order_created_at,
        delivered_at
    FROM {{ ref('stg_sql_server_dbo__orders') }}
)
SELECT
    order_id,
    shipping_cost,
    order_cost,
    order_total,
    order_created_at,
    delivered_at
FROM base_orders
