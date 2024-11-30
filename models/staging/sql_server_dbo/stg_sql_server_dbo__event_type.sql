{{
  config(
    materialized='table'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
),

type AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['event_type']) }} AS event_type_id,
        event_type,
        CASE
            WHEN event_type IN ('package_shipped', 'checkout') THEN 'order'
            ELSE 'product'
        END AS category
    FROM src_events
)

SELECT * 
FROM type