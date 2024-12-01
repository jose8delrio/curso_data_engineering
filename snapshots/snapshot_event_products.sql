{% snapshot snapshot_event_products %}

{{
    config(
        target_schema='snapshots',
        unique_key='event_id',
        strategy='timestamp',
        updated_at='event_products_date_load'
    )

}}

SELECT
    event_id,
    product_id,
    event_products_date_load
FROM {{ ref('int_sql_server_dbo__event_products') }}
{% endsnapshot %}