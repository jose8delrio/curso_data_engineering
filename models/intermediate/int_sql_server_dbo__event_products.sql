{{
  config(
    materialized='table'
  )
}}

WITH 
src_events AS (
    SELECT 
        event_id,
        CASE 
            WHEN product_id IS NOT NULL AND product_id != '' THEN product_id
            ELSE md5('no_product')
        END AS product_id,
        events_date_deleted,
        events_date_load
    FROM {{ ref('stg_sql_server_dbo__events') }}
)

SELECT DISTINCT
    event_id,
    product_id,
    events_date_deleted AS event_products_date_deleted,
    events_date_load AS event_products_date_load
FROM src_events