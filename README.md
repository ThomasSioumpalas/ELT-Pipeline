ELT Pipeline — Junior Dev README

A data pipeline that pulls raw data from Snowflake's sample dataset, transforms it using dbt, and loads the results back into Snowflake. Orchestrated with Apache Airflow running on Docker via Astronomer.

What This Project Does

Raw Snowflake data → cleaned in staging → joined and enriched in marts → final tables ready for analytics.

```
SNOWFLAKE_SAMPLE_DATA (raw)
        ↓
stg_tpch_orders + stg_tpch_line_items   (staging views)
        ↓
int_order_items + int_order_items_summary   (intermediate tables)
        ↓
fct_orders   (final fact table)
```

---

Tech Stack

| Tool              | Role                                                  |
| ----------------- | ----------------------------------------------------- |
| Apache Airflow    | Orchestration — schedules and runs the pipeline daily |
| dbt               | Transformation — runs SQL models against Snowflake    |
| Snowflake         | Data warehouse — stores raw and transformed data      |
| Astronomer Cosmos | Bridges Airflow and dbt automatically                 |
| Docker            | Runs everything locally via Astronomer runtime        |

How the Files Connect

1. **`dbt_dag.py`** — Airflow DAG that uses Astronomer Cosmos to read the dbt project and auto-generate one Airflow task per dbt model. It connects to Snowflake using the `snowflake_conn` connection configured in Airflow.

2. **`tpch_sources.yml`** — tells dbt where the raw data lives (`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`). This is the starting point of the pipeline.

3. **`stg_tpch_orders.sql` + `stg_tpch_line_items.sql`** — staging models that rename columns from cryptic names (`o_orderkey`) to readable ones (`order_key`). Created as views in Snowflake.

4. **`pricing.sql` macro** — a reusable formula for calculating discounts, called inside `int_order_items.sql` with `{{ discounted_amount(...) }}`.

5. **`int_order_items.sql`** — joins orders and line items together and applies the discount macro.

6. **`fct_orders.sql`** — the final output table that analytics teams query.

Running Locally

1. Start the project

```bash
astro dev start
```

Airflow will be available at http://localhost:8080 — login with `admin / admin`.

2. Add the Snowflake connection

Go to Admin → Connections → + and fill in:

| Field           | Value                                              |
| --------------- | -------------------------------------------------- |
| Connection ID   | `snowflake_conn`                                   |
| Connection Type | `Snowflake`                                        |
| Account         | your Snowflake account ID (e.g. `WLQZYHR-RG60452`) |
| Login           | your Snowflake username                            |
| Password        | your Snowflake password                            |
| Extra (JSON)    | see below                                          |

Extra field:

```json
{
  "warehouse": "COMPUTE_WH",
  "database": "dbt_db",
  "schema": "dbt_schema",
  "role": "ACCOUNTADMIN"
}
```

3. Create the output database in Snowflake

```sql
CREATE DATABASE IF NOT EXISTS dbt_db;
CREATE SCHEMA IF NOT EXISTS dbt_db.dbt_schema;
```

4. Trigger the DAG

In the Airflow UI, find `dbt_dag` and click the play button to trigger it manually.

**5. Check the results in Snowflake**

```sql
SELECT * FROM DBT_DB.DBT_SCHEMA.FCT_ORDERS LIMIT 10;
```
