{{
  config(
    materialized='view'
  )
}}

select * from {{ref('stg_sql_server_dbo__time')}}