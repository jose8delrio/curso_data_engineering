{{
  config(
    materialized='table'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
),

sessions AS (
    SELECT DISTINCT
        session_id,
        user_id
    FROM src_events
)

SELECT * 
FROM sessions
