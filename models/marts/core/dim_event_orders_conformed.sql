{{ config(materialized='incremental', unique_key='EVENT_ID') }}

WITH orders_per_event AS (
    SELECT
        EVENT_ID,
        ORDER_ID,
        1.0 / COUNT(EVENT_ID) OVER (PARTITION BY ORDER_ID) AS weight
    FROM {{ ref('snapshot_event_orders') }}

)

SELECT * FROM orders_per_event
