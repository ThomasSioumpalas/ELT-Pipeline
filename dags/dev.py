from airflow.decorators import dag, task # type: ignore
from pendulum import datetime # type: ignore
from dags.dbt_dag import dbt_snowflake_dag

@dag(
    dag_id="dev_dag",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["local"],
)
def dev_dag():
    @task
    def hello():
        return "hello from dev dag"

    hello()


dag = dev_dag()
