{% snapshot snapshot_event_orders %}

{{
    config(
        target_schema='snapshots',
        unique_key='event_id',
        strategy='timestamp',
        updated_at='event_orders_date_load'
    )

}}

SELECT
    event_id,
    order_id,
    event_orders_date_load
FROM {{ ref('int_sql_server_dbo__event_orders') }}
{% endsnapshot %}