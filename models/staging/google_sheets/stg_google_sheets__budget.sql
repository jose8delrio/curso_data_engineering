
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
),

products as (
    select
        product_id,
        price
    from {{ source('sql_server_dbo', 'products')  }}  -- Referencia al modelo o tabla 'products'
)

select
    b.BUDGET_ID,
    b.product_id,
    b.fecha_pedido_productos,
    b.month_of_year,
    b.Cantidad_A_Pedir,
    p.price as precio_producto,
    b.Cantidad_A_Pedir * p.price as Presupuesto_Producto  -- Multiplicación para calcular el precio total
from renamed_casted b
left join products p
    on b.product_id = p.product_id
