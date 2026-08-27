{% macro cents_to_dollars(column_name, decimal_places=2) %}
    round(({{ column_name }})::numeric, {{ decimal_places }})
{% endmacro %}