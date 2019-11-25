# Airflow Jenkins Slave

## Introduction / Used for building / testing `airflow`
This slave is used to build / execute / test [Airflow](https://airflow.apache.org/) code for `airflow-cluster` quickstarter.

The image is built in the global `cd` project and is named `jenkins-slave-airflow`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-airflow`

## Features / what's in, which plugins, ...
1. Python 3.6
2. PIP
3. NodeJS 8.x
4. Airflow 1.10.2

## Known limitations
Not (yet) Nexus package manager aware and no special HTTP Proxy configuration
