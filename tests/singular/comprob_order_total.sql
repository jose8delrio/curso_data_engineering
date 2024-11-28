WITH OriginalCost AS (
    -- Calculamos el costo original de cada pedido sumando el precio * cantidad de cada producto
    SELECT 
        oi.order_id,
        SUM(p.price * oi.Cantidad_Pedida_Producto) AS original_cost
    FROM {{ref('stg_sql_server_dbo__order_items')}} oi
    JOIN {{ref('stg_sql_server_dbo__products')}} p ON oi.product_id = p.product_id
    GROUP BY oi.order_id
),
OrderDetails AS (
    -- Unimos los detalles de las órdenes con los costos originales y las promociones
    SELECT 
        o.order_id,
        o.promo_id,
        o.order_cost,
        o.shipping_cost,
        o.order_total,
        COALESCE(oc.original_cost, 0) AS original_cost,
        COALESCE(p.discount, 0) AS discount,
        p.status
    FROM {{ref('stg_sql_server_dbo__orders')}} o
    LEFT JOIN OriginalCost oc ON o.order_id = oc.order_id
    LEFT JOIN {{ref('stg_sql_server_dbo__promos')}} p ON o.promo_id = p.promo_id
),
Validation AS (
    -- Comparamos el costo final con el costo esperado basado en descuentos
    SELECT 
        od.order_id,
        od.promo_id,
        od.original_cost,
        od.order_cost,
        od.shipping_cost,
        od.order_total,
        od.discount,
        od.status,
        CASE 
            -- Si la promoción está activa o inactiva, aplica el descuento
            WHEN od.status = 'active' OR od.status = 'inactive' THEN 
                od.original_cost + od.shipping_cost - od.discount
            ELSE 
                od.original_cost + od.shipping_cost  -- Si no hay promoción, usamos el costo sin descuento
        END AS expected_total
    FROM OrderDetails od
)
-- Mostramos los resultados para verificar si el descuento está aplicado correctamente
SELECT *,
    CASE 
        -- Comparación con tolerancia para evitar problemas de precisión
        WHEN ABS(order_total - expected_total) < 0.01 THEN 'Yes'
        ELSE 'No'
    END AS discount_applied_correctly
FROM Validation
WHERE discount_applied_correctly= 'No'