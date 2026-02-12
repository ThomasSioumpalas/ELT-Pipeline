FROM quay.io/astronomer/astro-runtime:12.6.0

RUN python -m venv dbt_venv && \
    ./dbt_venv/bin/pip install --no-cache-dir dbt-snowflake