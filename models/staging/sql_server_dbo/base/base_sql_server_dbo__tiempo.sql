{{
  config(
    materialized='view'
  )
}}

{{ dbt_date.get_date_dimension(start_date="2021-01-01", end_date="2022-12-31") }} --probar con un prehook