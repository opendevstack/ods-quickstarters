#!/usr/bin/env bash

if `python -c "import xmlrunner" 2> /dev/null`; then
    MODULE=xmlrunner
    OUTPUT="-o ./build/test-results/test"
else
    MODULE=unittest
    OUTPUT=""
fi

PYTHONPATH="src/dag_deps:tests" exec python -m $MODULE discover -s tests -p '*.py' $OUTPUT