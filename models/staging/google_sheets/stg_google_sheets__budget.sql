
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
    from {{ source('sql_server_dbo', 'products')  }}  -- Referencia al modelo 'products'
)

select
    b.BUDGET_ID,
    b.product_id,
    b.year,
    b.month_of_year,
    b.quantity_budget,
    p.price as product_price,
    ROUND(b.quantity_budget * p.price,2) as budget_per_product,  -- Multiplicación para calcular el precio total
    coalesce (null, FALSE) AS budget_date_deleted,
    b.budget_date_load as budget_date_load
from base_budget b
left join products p
    on b.product_id = p.product_id
