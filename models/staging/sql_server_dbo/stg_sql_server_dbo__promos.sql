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
        status,
        _fivetran_deleted,
        _fivetran_synced
    from src_promos
),

-- Agregar una fila adicional para la no_promo
with_extra_row as (
    select *
    from renamed
    union all
    select
        md5('no_promo') as promo_id, -- Genera un hash único para 'no_promo'
        'no_promo' as desc_promo,    -- Descripción personalizada
        cast(null as number(38,0)) as discount, -- Número con precisión
        cast(null as varchar(256)) as status,   -- Cadena de texto
        cast(null as boolean) as _fivetran_deleted, -- Valor booleano
        cast(null as timestamp_tz(9)) as _fivetran_synced -- Timestamp con zona horaria
)

select * from with_extra_row
