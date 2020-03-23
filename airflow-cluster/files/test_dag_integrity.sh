#!/usr/bin/env bash

for i in src/dags/*.py; do
    if [[ -f $i ]]; then
        printf "$i... "
        if `python $i > /dev/null 2> /dev/null`; then
            echo "OK"
        else
            echo "NOK"
            exit 1
        fi
    fi
done;


if `python -c "import xmlrunner" 2> /dev/null`; then
    MODULE=xmlrunner
    OUTPUT="-o ./build/test-results/test"
else
    MODULE=unittest
    OUTPUT=""
fi

PYTHONPATH="src/dag_deps:tests" exec python -m $MODULE dags.test_dag_integrity $OUTPUT