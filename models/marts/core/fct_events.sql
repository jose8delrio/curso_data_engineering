{{ config(
    materialized='incremental', 
    unique_key='EVENT_ID'
) }}

WITH base_events AS (
    SELECT
        event_id,
        user_id,
        --product_id,
        session_id,
        event_type_id,
        page_url,
        event_created_at,
        events_date_deleted,
        events_date_load
    FROM {{ ref('stg_sql_server_dbo__events') }}
)

SELECT * FROM base_events
