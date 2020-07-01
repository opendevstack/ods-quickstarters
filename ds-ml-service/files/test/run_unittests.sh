#!/usr/bin/env bash
cd test/unittests &&
python -m pytest --junitxml=tests.xml --cov-report term-missing --cov-report xml --cov=. -o junit_family=xunit2
