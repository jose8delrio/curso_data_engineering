
{{
  config(
    materialized='view'
  )
}}

WITH base_budget AS (
    SELECT * 
    FROM {{ ref("base_google_sheets__budget") }}
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
    b.date_to_order,
    b.month_of_year,
    b.quantity_budget,
    p.price as precio_producto,
    ROUND(b.quantity_budget * p.price,2) as Presupuesto_Producto,  -- Multiplicación para calcular el precio total
    b.date_load_utc as date_load_utc
from base_budget b
left join products p
    on b.product_id = p.product_id
