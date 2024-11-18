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
        quantity,
        _fivetran_deleted,
        _fivetran_synced

    from src_order_items

)

select * from renamed
