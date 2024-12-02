{{
  config(
    materialized='table'
  )
}}

WITH jointiempo as (
    select 
        time_id,
        date_day
    from {{ ref('stg_sql_server_dbo__time') }}
),

base_orders AS (
    SELECT
        order_id,
        j.time_id,
        shipping_cost,
        order_cost,
        order_total,
        order_created_at,
        delivered_at
    FROM {{ ref('stg_sql_server_dbo__orders') }} o
    LEFT JOIN jointiempo j
        ON j.date_day=o.order_created_at::date
)
SELECT *
FROM base_orders
