
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
          _row
        , product_id
        , quantity
        , month AS fecha_pedido_productos
        , TO_CHAR(month, 'Mon') AS month_of_year
        , _fivetran_synced AS date_load
    FROM src_budget
)

SELECT * FROM renamed_casted
