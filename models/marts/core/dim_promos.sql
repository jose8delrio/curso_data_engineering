{{
  config(
    materialized='table'
  )
}}

select * from {{ref('stg_sql_server_dbo__promos')}}