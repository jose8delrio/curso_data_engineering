SELECT
    e.page_url,
    p.product_id,
    p.product_name,
    COUNT(DISTINCT e.event_id) AS page_view_count,
    COUNT(DISTINCT o.order_item_id) AS sales_count,
    CASE 
        WHEN COUNT(DISTINCT o.order_item_id) = 0 THEN 0
        ELSE COUNT(DISTINCT e.event_id) * 1.0 / COUNT(DISTINCT o.order_item_id)
    END AS visit_to_sales_ratio -- Visitas por venta
FROM
    {{ ref('fct_events') }} e
JOIN
    {{ ref('dim_bridge_event_products') }} bep ON e.event_id = bep.event_id
JOIN
    {{ ref('dim_products') }} p ON bep.product_id = p.product_id
LEFT JOIN
    {{ ref('fct_order_items') }} o ON p.product_id = o.product_id
WHERE
    e.page_url IS NOT NULL
GROUP BY
    e.page_url, p.product_id, p.product_name
ORDER BY
    visit_to_sales_ratio DESC