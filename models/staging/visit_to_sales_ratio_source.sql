WITH unique_sales AS (
    -- Desduplicar ventas únicas por producto y orden
    SELECT DISTINCT
        order_items.PRODUCT_ID,
        order_items.ORDER_ID,
        order_items.QUANTITY
    FROM
        {{ source('sql_server_dbo', 'order_items') }} AS order_items
    JOIN
        {{ source('sql_server_dbo', 'orders') }} AS orders
    ON order_items.ORDER_ID = orders.ORDER_ID
),
sales_data AS (
    -- Calcular ventas totales por producto
    SELECT
        PRODUCT_ID,
        SUM(QUANTITY) AS total_quantity
    FROM
        unique_sales
    GROUP BY
        PRODUCT_ID
),
page_views AS (
    -- Calcular visitas únicas a páginas desde events
    SELECT
        events.PAGE_URL,
        events.PRODUCT_ID,
        COUNT(DISTINCT events.EVENT_ID) AS page_view_count -- Total de eventos únicos por producto
    FROM
        {{ source('sql_server_dbo', 'events') }} AS events
    WHERE
        events.PAGE_URL IS NOT NULL
    GROUP BY
        events.PAGE_URL, events.PRODUCT_ID
)
SELECT
    pv.PAGE_URL AS page_url,
    pv.PRODUCT_ID AS product_id,
    products.NAME AS product_name,
    pv.page_view_count,
    COALESCE(sd.total_quantity, 0) AS sales_count, -- Ventas totales asociadas al producto
    CASE 
        WHEN COALESCE(sd.total_quantity, 0) = 0 THEN 0
        ELSE pv.page_view_count * 1.0 / COALESCE(sd.total_quantity, 0)
    END AS visit_to_sales_ratio -- Ratio de eventos a ventas
FROM
    page_views AS pv
LEFT JOIN
    sales_data AS sd ON pv.PRODUCT_ID = sd.PRODUCT_ID
LEFT JOIN
    {{ source('sql_server_dbo', 'products') }} AS products ON pv.PRODUCT_ID = products.PRODUCT_ID
ORDER BY
    visit_to_sales_ratio DESC