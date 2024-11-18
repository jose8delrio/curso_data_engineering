
{{
  config(
    materialized='view'
  )
}}


with 

src_events as (

    select * from {{ source('sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at,
        order_id,
        _fivetran_deleted,
        _fivetran_synced

    from src_events

)

select * from renamed
