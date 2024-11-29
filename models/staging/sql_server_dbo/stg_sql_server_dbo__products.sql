
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
        price as product_price,
        name as product_name,
        inventory as product_inventory,
        coalesce(_fivetran_deleted, FALSE) AS product_date_deleted,
        convert_timezone('UTC', _fivetran_synced) as product_date_load

    from src_products

)

select * from renamed
