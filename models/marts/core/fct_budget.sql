{{ config(
    materialized='incremental', 
    unique_key='BUDGET_ID'
) }}

WITH stg_budget AS (
    SELECT
        BUDGET_ID,
        product_id,
        {{dbt_utils.generate_surrogate_key(['budget_date'])}} as time_id,
        year,
        month_of_year,
        quantity_budget,
        product_price,
        budget_per_product,
        budget_date_deleted,
        budget_date_load
    FROM {{ ref('stg_google_sheets__budget') }}
)

SELECT *
FROM stg_budget
