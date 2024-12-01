
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
        user_id,
        product_id,
        session_id,
        order_id,
        {{dbt_utils.generate_surrogate_key(['event_type'])}} as event_type_id,
        page_url,
        convert_timezone('UTC', created_at) as event_created_at,
        coalesce(_fivetran_deleted, FALSE) AS events_date_deleted,
        convert_timezone('UTC', _fivetran_synced) as events_date_load

    from src_events

)

select * from renamed
