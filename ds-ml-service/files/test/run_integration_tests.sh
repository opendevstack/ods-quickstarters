#!/usr/bin/env bash
PYTHONPATH=. nosetests -v --with-xunit --with-coverage --cover-xml --cover-erase --cover-inclusive --cover-package=.