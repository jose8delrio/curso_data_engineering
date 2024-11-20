
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
        , quantity AS Cantidad_A_Pedir
        , month AS fecha_pedido_productos
        , monthname(month) AS month_of_year
        , _fivetran_synced AS date_load
    FROM src_budget
)

SELECT * FROM renamed_casted
