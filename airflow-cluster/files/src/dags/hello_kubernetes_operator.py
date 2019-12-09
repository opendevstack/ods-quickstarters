"""
Code that goes along with the Airflow tutorial located at:
https://github.com/apache/airflow/blob/master/airflow/example_dags/tutorial.py
"""

from datetime import datetime, timedelta

from airflow import configuration
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.models import DAG

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

dag = DAG('Hello_Kubernetes_Operator_DAG', default_args=default_args, schedule_interval=timedelta(days=1))

namespace = configuration.conf.get("kubernetes","namespace")

t1 = KubernetesPodOperator(
    namespace=namespace,
    image="ubuntu:16.04",
    cmds=["bash", "-cx"],
    arguments=["echo", "10"],
    name="echo",
    in_cluster=True,
    task_id="echo",
    is_delete_operator_pod=True,
    dag=dag
)

t2 = KubernetesPodOperator(
    namespace=namespace,
    image="registry.access.redhat.com/rhscl/python-36-rhel7",
    cmds=["python", "--version"],
    arguments=["echo", "10"],
    name="python-version",
    in_cluster=True,
    task_id="pythonversion",
    is_delete_operator_pod=True,
    dag=dag
)

t1.set_downstream(t2)
