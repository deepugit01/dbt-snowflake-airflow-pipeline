{% macro safe_cast_date(column_expression) %}
    coalesce(
        try_to_date({{ column_expression }}, 'YYYY-MM-DD'),
        try_to_date({{ column_expression }}, 'DD/MM/YYYY'),
        try_to_date({{ column_expression }}, 'MM-DD-YYYY'),
        try_to_date({{ column_expression }}, 'DD-MON-YYYY'),
        try_to_date({{ column_expression }}, 'YYYYMMDD')
    )
{% endmacro %}