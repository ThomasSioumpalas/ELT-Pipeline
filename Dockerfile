FROM quay.io/astronomer/astro-runtime:12.6.0

# Create the dbt virtual environment
RUN python -m venv dbt_venv && \
    source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-snowflake && deactivate

# Set an environment variable to make referencing the venv easier in DAGs
ENV DBT_VENV_PATH=/usr/local/airflow/dbt_venv