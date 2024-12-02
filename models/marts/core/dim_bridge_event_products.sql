{{ config(materialized='incremental', unique_key='EVENT_ID') }}

WITH products_per_event AS (
    SELECT
        EVENT_ID,
        PRODUCT_ID,
        1.0 / COUNT(EVENT_ID) OVER (PARTITION BY PRODUCT_ID) AS weight
    FROM {{ ref('snapshot_event_products') }}
)

SELECT * 
FROM products_per_event
