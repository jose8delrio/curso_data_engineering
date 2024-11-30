{{
  config(
    materialized='table'
  )
}}

WITH source AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
),

countries AS (
    SELECT 
        country_id,
        country_name
    FROM {{ ref('base_sql_server_dbo__countries') }}
)

SELECT
    s.address_id,
    c.country_id AS country_id, 
    s.zipcode,
    s.address,
    s.state,
    COALESCE(s._fivetran_deleted, FALSE) AS address_date_deleted,
    CONVERT_TIMEZONE('UTC', s._fivetran_synced) AS address_date_load
FROM 
    source s
LEFT JOIN 
    countries c
ON 
    s.country = c.country_name 

