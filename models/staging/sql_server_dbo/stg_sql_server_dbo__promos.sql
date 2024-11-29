{{
  config(
    materialized='view'
  )
}}

with src_promos as (
    select * 
    from {{ source('sql_server_dbo', 'promos') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} as promo_id,
        promo_id as desc_promo,
        discount,
        status as promo_status,
        coalesce(_fivetran_deleted, FALSE) AS promo_date_deleted,
        convert_timezone('UTC', _fivetran_synced) as promo_date_load
    from src_promos
),

-- Agrego una fila adicional para la no_promo
with_extra_row as (
    select *
    from renamed
    union all
    select
        md5('no_promo') as promo_id, -- Genera un hash único para 'no_promo'
        'no_promo' as desc_promo,    -- Descripción no_promo
        cast(0 as number(38,0)) as discount, -- descuento no promo
        cast('active' as varchar(256)) as promo_status,   -- la no_promo está siempre activa
        cast(FALSE as boolean) as promo_date_deleted, -- Valor booleano
        convert_timezone('UTC', cast(CURRENT_TIMESTAMP() as timestamp_tz(9))) as promo_date_load -- Timestamp con zona horaria
)

select * from with_extra_row
