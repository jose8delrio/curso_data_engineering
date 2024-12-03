SELECT
    u.first_name,                                         -- Nombre del usuario
    u.last_name,                                          -- Apellido del usuario
    u.email,                                              -- Correo electrónico del usuario
    u.phone_number,                                       -- Número de teléfono del usuario
    oioc.user_id,                                         -- Identificador del usuario
    COUNT(DISTINCT oioc.order_id) AS total_orders         -- Número total de pedidos realizados por el usuario
FROM
    {{ ref('dim_users') }} u                             -- Tabla de usuarios
JOIN
    {{ ref('dim_order_order_items_conformed') }} oioc    -- Tabla de órdenes e ítems asociados
    ON u.user_id = oioc.user_id                          -- Relacionamos por el user_id
GROUP BY
    u.first_name,                                        -- Agrupamos por nombre
    u.last_name,                                         -- Agrupamos por apellido
    u.email,                                              -- Agrupamos por correo electrónico
    u.phone_number,                                       -- Agrupamos por número de teléfono
    oioc.user_id                                         -- Agrupamos por user_id
HAVING
    COUNT(DISTINCT oioc.order_id) > 0                    -- Aseguramos que haya realizado al menos un pedido
ORDER BY
    total_orders DESC                                   -- Ordenamos por el número total de pedidos
