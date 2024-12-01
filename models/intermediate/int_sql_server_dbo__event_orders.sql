{{
  config(
    materialized='table'
  )
}}

WITH 
src_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__events') }}
),

event_order_mapping AS (
    SELECT
        event_id,
        CASE 
            WHEN order_id IS NOT NULL AND order_id != '' THEN order_id
            ELSE md5('no_order')
        END AS order_id,
        events_date_deleted,
        events_date_load
    FROM src_events
)

SELECT DISTINCT 
    event_id,
    order_id,
    events_date_deleted AS event_orders_date_deleted,
    events_date_load AS event_orders_date_load
FROM event_order_mapping
