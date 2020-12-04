# IaaS Jenkins Slave

## Introduction / Used for deploying AWS/Azure stacks
This slave is used to build and deploy AWS & Azure workloads in the cloud


The image is built in the global `cd` project and is named `jenkins-slave-iaas`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-iaas` 

## Features / what's in, which plugins, ...
1.  Deployment of AWS Cloud Services
2.  Terraform 0.12.20
3.  Terraform Docs 0.8.2
4.  Python 3.7.3
5.  Ruby 2.6.1
6.  Packer 1.5.1
7.  Consul client 1.6.3
8.  Inspec 3.9.3  

## Known limitations
MS Azure support not available at this time.
