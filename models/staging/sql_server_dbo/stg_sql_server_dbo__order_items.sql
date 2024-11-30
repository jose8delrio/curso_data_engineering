{{
  config(
    materialized='view'
  )
}}

with 

src_order_items as (

    select * from {{ source('sql_server_dbo', 'order_items') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity as quantity_product,
        coalesce(_fivetran_deleted, FALSE) AS order_items_date_deleted,
        convert_timezone('UTC', _fivetran_synced) as order_items_date_load

    from src_order_items

)

select * from renamed
