{{ config(
    materialized='incremental', 
    unique_key='EVENT_ID'
) }}

WITH jointiempo as (
    select 
        time_id,
        date_day
    from {{ ref('stg_sql_server_dbo__time') }}
),

base_events AS (
    SELECT
        event_id,
        user_id,
        --product_id,
        session_id,
        event_type_id,
        j.time_id as time_id,
        page_url,
        event_created_at,
        events_date_deleted,
        events_date_load
    FROM {{ ref('stg_sql_server_dbo__events') }} e
    full JOIN jointiempo j
    on j.date_day=e.event_created_at::date
)

SELECT * FROM base_events
