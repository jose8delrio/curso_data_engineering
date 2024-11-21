{{
  config(
    materialized='view'
  )
}}

{{ dbt_date.get_date_dimension(start_date="2021-02-11", end_date="2022-02-11") }}