SELECT
    a.state,                                                -- Estado desde dim_addresses
    round(SUM(o.order_total),2) AS total_sales,                       -- Total de ventas por estado
    COUNT(oi.product_id) AS total_products_sold,             -- Total de productos vendidos por estado
    MAX(p.product_name) AS most_sold_product,                -- Producto más vendido
FROM
    {{ ref('fct_orders') }} o
JOIN
    {{ ref('dim_order_order_items_conformed') }} oi_conformed
    ON o.order_id = oi_conformed.order_id                   -- Relación entre fct_orders y dim_order_order_items_conformed
JOIN
    {{ ref('dim_addresses') }} a
    ON oi_conformed.address_id = a.address_id               -- Relación entre dim_order_order_items_conformed y dim_addresses
JOIN
    {{ ref('fct_order_items') }} oi
    ON oi_conformed.order_item_id = oi.order_item_id        -- Relación entre dim_order_order_items_conformed y fct_order_items
JOIN
    {{ ref('dim_products') }} p
    ON oi.product_id = p.product_id                         -- Relación entre fct_order_items y dim_products
GROUP BY
    a.state                                                -- Agrupar por estado
ORDER BY
    total_sales DESC                                        -- Ordenar por total de ventas
