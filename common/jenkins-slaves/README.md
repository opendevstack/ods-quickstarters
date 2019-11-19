# Jenkins Slaves

Hosts all the jenkins slaves that are part of the OpenDevStack distribution.

All these slaves inherit from the [slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base), and are built in the global `CD` project. 

Inside your `jenkinsfile` you can configure which slave is used by changing the `image` property to your imagestream (e.g. in case it's in a `project`-cd namespace and not in the global `CD` one).
```
odsPipeline(
  image: "${dockerRegistry}/cd/jenkins-slave-maven"
```
the ODS [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library) takes care about starting the `jenkins slave` during the build as pod in your `project`s `cd` namespace with the `jenkins` service account.

### Currently available slaves
1. [Maven / Gradle](maven/README.md) 
1. [nodeJS 10](nodejs10-angular/README.md)
1. [Scala & SBT](scala/README.md)
1. [Python](python/README.md)

If you create a new slave please add a `README.md` inside its directory, based on [this template](../__JENKINS_SLAVE_TEMPLATE_README.md). 

## OCP config / installation

Config can be created / updated / deleted with Tailor.

Example:
```
cd <slave name>/ocp-config && tailor status
```
