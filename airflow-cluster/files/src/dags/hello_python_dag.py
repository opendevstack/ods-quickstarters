"""
Code that goes along with the Airflow tutorial located at:
https://github.com/apache/airflow/blob/master/airflow/example_dags/tutorial.py
"""

from random import random
from operator import add

from datetime import datetime, timedelta

from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator

def python_callable():
    print("I am a python function")

def python_callable_dag_deps():
    from dag_deps_package.crazy_python import MessagingClass

    print(MessagingClass("I am importing from dag_deps"))

def python_callable_modules():
    from pyspark.sql import SparkSession
    spark = SparkSession.builder.appName("SimpleApp").master("local[*]").getOrCreate()

    partitions = 2
    n = 100 * partitions

    def f(_):
        x = random() * 2 - 1
        y = random() * 2 - 1
        return 1 if x ** 2 + y ** 2 <= 1 else 0

    count = spark.sparkContext.parallelize(range(1, n + 1), partitions).map(f).reduce(add)
    print("Pi is roughly %f" % (4.0 * count / n))

    spark.stop()



default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2019, 3, 4),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(days=30),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
}

dag = DAG('Hello_Python_DAG', default_args=default_args, schedule_interval=timedelta(days=1))

t1 = BashOperator(
    task_id='print_date',
    bash_command='date',
    dag=dag)

t2 = BashOperator(
    task_id='sleep',
    bash_command='sleep 5',
    retries=3,
    dag=dag)

templated_command = """
    {% for i in range(5) %}
        echo "{{ ds }}"
        echo "{{ macros.ds_add(ds, 7)}}"
        echo "{{ params.my_param }}"
    {% endfor %}
"""

t3 = BashOperator(
    task_id='templated',
    bash_command=templated_command,
    params={'my_param': 'Parameter I passed in'},
    dag=dag)

t4 = PythonOperator(
    task_id='python_task',
    python_callable=python_callable,
    dag=dag
)

t5 = PythonOperator(
    task_id='python_task_dag_deps',
    python_callable=python_callable_dag_deps,
    dag=dag
)


t6 = PythonOperator(
    task_id='python_task_modules',
    python_callable=python_callable_modules,
    dag=dag
)

t1.set_downstream(t2)
t1.set_downstream(t3)
t3.set_downstream(t4)
t2.set_downstream(t5)
t4.set_downstream(t6)
