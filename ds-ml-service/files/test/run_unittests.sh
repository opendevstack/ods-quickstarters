#!/usr/bin/env bash
cd test/unittests &&
PYTHONPATH=. nosetests -v --with-xunit --with-coverage --cover-xml --cover-erase --cover-inclusive --cover-package=../..