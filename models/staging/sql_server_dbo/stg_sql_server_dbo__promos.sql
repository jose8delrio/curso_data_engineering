
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
        promo_id,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced
    from src_promos
)

select * from renamed
