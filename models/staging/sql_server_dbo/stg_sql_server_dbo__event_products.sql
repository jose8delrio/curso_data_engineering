{{
  config(
    materialized='table'
  )
}}

WITH 
src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
),

event_product_mapping AS (
    SELECT
        event_id,
        CASE 
            WHEN product_id IS NOT NULL AND product_id != '' THEN product_id
            ELSE md5('no_product')
        END AS product_id
    FROM src_events
)

SELECT DISTINCT 
    event_id,
    product_id
FROM event_product_mapping
