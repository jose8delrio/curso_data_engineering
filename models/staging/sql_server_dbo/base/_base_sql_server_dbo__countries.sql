{{
  config(
    materialized='table'
  )
}}

WITH data AS (
    SELECT 
        'United States' AS country_name
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['country_name']) }} AS country_id,
    country_name
FROM 
    data

