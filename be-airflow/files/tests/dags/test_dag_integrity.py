import collections
import os
import sys
import unittest
from importlib import import_module

from airflow.models import DagBag, DAG


class TestDagIntegrity(unittest.TestCase):
    LOAD_SECOND_THRESHOLD = 2
    DAG_FOLDER = "src/dags"

    def setUp(self):
        self.dagbag = DagBag(dag_folder=TestDagIntegrity.DAG_FOLDER, include_examples=False)

    def test_import_dags(self):
        self.assertFalse(
            len(self.dagbag.import_errors),
            'DAG import failures. Errors: {}'.format(
                self.dagbag.import_errors
            )
        )

    def test_name_uniqness(self):

        sys.path.insert(0, TestDagIntegrity.DAG_FOLDER)
        dags = []
        dag_paths = {}
        for f in os.listdir(TestDagIntegrity.DAG_FOLDER):
            if f.startswith((".", "_")):
                continue

            m = import_module(f[:-3])
            for dag in list(m.__dict__.values()):
                if isinstance(dag, DAG):
                    dags.append(m.dag)
                    dag_id = m.dag.dag_id

                    if dag_id not in dag_paths:
                        dag_paths[dag_id] = []
                    dag_paths[dag_id].append(f)

        dag_ids = [dag.dag_id for dag in dags]

        self.assertEqual(len(dag_ids), len(set(dag_ids)), "There is DAGs with the same ID. Duplicates are {0}.".format(
            [(item, dag_paths[item]) for item, count in collections.Counter(dag_ids).items() if count > 1]))

    def test_empty_dag(self):

        for dag_id, dag in self.dagbag.dags.items():
            if dag.folder == TestDagIntegrity.DAG_FOLDER:
                self.assertTrue(len(dag.tasks) >= 1,
                                "In dag '{0}' there is no tasks".format(dag_id, dag))

    def test_add_dependencies(self):

        for dag_id, dag in self.dagbag.dags.items():
            lone_wolfs = []
            if len(dag.tasks) <= 1 or dag.folder != TestDagIntegrity.DAG_FOLDER:
                continue
            for task in dag.tasks:
                relatives = task.get_direct_relative_ids(upstream=False).union(
                    task.get_direct_relative_ids(upstream=True))
                if not relatives:
                    lone_wolfs.append(task)

            self.assertEqual(len(lone_wolfs), 0,
                                "In dag '{0}' ({1}) there is tasks ({2}) without dependencies.".format(dag_id,
                                                                                                       dag.filepath,
                                                                                                       lone_wolfs))
