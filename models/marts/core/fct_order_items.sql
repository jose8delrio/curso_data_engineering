-- models/fct_order_items.sql

with order_items as (
    select
        order_id,
        product_id,
        quantity_product,
        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as order_item_id
    from {{ ref('stg_sql_server_dbo__order_items') }}
),

products as (
    select
        product_id,
        product_price
    from {{ ref('stg_sql_server_dbo__products') }}
),

calculated as (
    select
        oi.order_item_id,
        oi.order_id,
        oi.product_id,
        oi.quantity_product,
        p.product_price,
        (oi.quantity_product * p.product_price) as product_total_cost
    from order_items oi
    left join products p
        on oi.product_id = p.product_id
)

select
    order_item_id,
    product_id,
    quantity_product,
    product_total_cost
from calculated