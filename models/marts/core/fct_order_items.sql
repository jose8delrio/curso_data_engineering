{{
  config(
    materialized='table'
  )
}}


WITH base_items AS (
    SELECT
        oi.order_id,
        oi.product_id,
        oi.quantity_product,
        (oi.quantity_product * p.product_price) AS product_total_cost
    FROM {{ ref('stg_sql_server_dbo__order_items') }} AS oi
    LEFT JOIN {{ ref('stg_sql_server_dbo__products') }} AS p
        ON oi.product_id = p.product_id
)
SELECT
    order_id,
    product_id,
    quantity_product,
    product_total_cost
FROM base_items