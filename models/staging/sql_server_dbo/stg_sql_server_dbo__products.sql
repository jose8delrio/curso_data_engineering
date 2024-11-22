
{{
  config(
    materialized='view'
  )
}}
with 

src_products as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted as date_deleted_utc,
        CONVERT_TIMEZONE('UTC', TO_TIMESTAMP_TZ(_fivetran_synced)) as date_load_utc

    from src_products

)

select * from renamed
