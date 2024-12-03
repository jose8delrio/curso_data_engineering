with addresses as (
    select distinct
        address_id,
        country_id,
        address,
        state,
        zipcode
    from {{ ref('stg_sql_server_dbo__addresses') }}
)

select * from addresses
