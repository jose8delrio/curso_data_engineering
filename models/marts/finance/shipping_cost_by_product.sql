WITH order_items_extended AS (
    SELECT
        foi.order_item_id,
        foi.product_id,
        foi.quantity_product,
        foi.product_total_cost,
        doc.order_id
    FROM {{ ref('fct_order_items') }} foi
    JOIN {{ ref('dim_order_conformed') }} doc
        ON foi.order_item_id = doc.order_id

),
order_items_with_shipping AS (
    SELECT
        oie.order_item_id,
        oie.product_id,
        oie.quantity_product,
        oie.product_total_cost,
        fo.shipping_cost,
        -- Proporción del costo de cada producto en el total del pedido
        oie.product_total_cost / nullif(SUM(oie.product_total_cost) OVER (PARTITION BY oie.order_id), 0) AS cost_ratio,
        -- Proporción de la cantidad de productos en el total del pedido
        oie.quantity_product / nullif(SUM(oie.quantity_product) OVER (PARTITION BY oie.order_id), 0) AS quantity_ratio
    FROM order_items_extended oie
    JOIN {{ ref('fct_orders') }} fo
        ON oie.order_id = fo.order_id
),
shipping_cost_calculated AS (
    SELECT
        order_item_id,
        product_id,
        shipping_cost,
        -- Distribución proporcional del costo de envío por el costo total del producto
        shipping_cost * cost_ratio AS shipping_cost_per_product_cost_ratio,
        -- Distribución proporcional del costo de envío por la cantidad de productos
        shipping_cost * quantity_ratio AS shipping_cost_per_product_quantity_ratio
    FROM order_items_with_shipping
)
SELECT
    product_id,
    order_item_id,
    shipping_cost_per_product_cost_ratio AS shipping_cost_per_product
FROM shipping_cost_calculated