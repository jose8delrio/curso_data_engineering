
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
)

select * from renamed
