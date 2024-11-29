{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
),

renamed_casted AS (
    SELECT
          {{ dbt_utils.generate_surrogate_key(['product_id', 'month']) }} as BUDGET_ID
        , product_id
        , quantity AS quantity_budget
        , month AS date_to_order_budget
        , monthname(month) AS month_of_year
        , year(month) AS year
        , CONVERT_TIMEZONE('UTC', TO_TIMESTAMP_TZ(_fivetran_synced)) AS budget_date_load
    FROM src_budget
)

select * from renamed_casted