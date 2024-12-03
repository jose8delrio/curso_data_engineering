{% macro generate_user_address_key(user_id, address_id) %}
{{ dbt_utils.generate_surrogate_key([user_id, address_id]) }}
{% endmacro %}