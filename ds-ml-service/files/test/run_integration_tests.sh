#!/usr/bin/env bash
python -m pytest --junitxml=tests.xml --cov-report term-missing --cov-report xml --cov=mlservice -o junit_family=xunit2 test
