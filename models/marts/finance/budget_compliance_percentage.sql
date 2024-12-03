WITH budget_data AS (
    SELECT
        b.product_id,
        p.product_name,
        SUM(b.quantity_budget) AS total_budget_quantity -- Presupuesto total por producto
    FROM
        {{ ref('fct_budget') }} b
    JOIN
        {{ ref('dim_products') }} p ON b.product_id = p.product_id
    GROUP BY
        b.product_id, p.product_name
)
SELECT
    bd.product_id,
    bd.product_name,
    bd.total_budget_quantity,
    COALESCE(SUM(oi.quantity_product), 0) AS total_sold_quantity, -- Ventas totales por producto
    -- Calculando la desviación entre presupuesto y ventas
    COALESCE(SUM(oi.quantity_product), 0) - bd.total_budget_quantity AS quantity_deviation, 
    -- Calculando el porcentaje de cumplimiento del presupuesto
    CASE 
        WHEN bd.total_budget_quantity = 0 THEN 0
        ELSE (COALESCE(SUM(oi.quantity_product), 0) / bd.total_budget_quantity) * 100 
    END AS budget_compliance_percentage
FROM
    budget_data bd
LEFT JOIN
    {{ ref('fct_order_items') }} oi ON bd.product_id = oi.product_id
GROUP BY
    bd.product_id, bd.product_name, bd.total_budget_quantity
ORDER BY
    budget_compliance_percentage DESC