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

event_order_mapping AS (
    SELECT
        event_id,
        CASE 
            WHEN order_id IS NOT NULL AND order_id != '' THEN order_id
            ELSE md5('no_order')
        END AS order_id
    FROM src_events
)

SELECT DISTINCT 
    event_id,
    order_id
FROM event_order_mapping
