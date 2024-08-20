# {{project-name}} - provisioned from the OpenDevStack Java/Spring Boot QuickStarter (be-java-springboot)

The official OpenDevStack documentation for this QuickStarter can be found [here](https://www.opendevstack.org/ods-documentation/opendevstack/latest/quickstarters/be-java-springboot.html).

### Adding Gradle cache to your CI/CD pipeline

One can improve the build pipeline time by adding a Gradle cache. This way, `gradlew` can use 
previously downloaded distributions instead of downloading them from the internet on every build.
To do so, follow the steps below:

- Create a `PersistentVolumeClaim` (PVC) with the name `gradle-cache` in your `{{project-name}}-cd`-namespace,
either via the OpenShift UI or via `oc` like this:
```
oc create -n {{project-name}}-cd -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
name: gradle-cache
spec:
accessModes:
- ReadWriteOnce
resources:
requests:
storage: 2Gi
EOF
```
The above needs to be done only once per project, as this PVC can be reused for other components within the same project.

- In your `Jenkinsfile`, mount this PVC to the containers of the pipeline by adding it as a podVolume:
```
...
odsComponentPipeline(
  podContainers: [
    ...
  ],
  podVolumes: [
    persistentVolumeClaim(claimName: "gradle-cache", mountPath: "/.gradle-cache", readOnly: false)
  ],
  branchToEnvironmentMapping: [
    ...
  ]
)
...
```

- Add this mount path as an env var called `GRADLE_USER_HOME` in the build stage to be picked up by Gradle:
```
...
def stageBuild(def context) {
  stage('Build and Unit Test') {
    withEnv(["TAGVERSION=${context.tagversion}",...,"GRADLE_USER_HOME=/.gradle-cache",...]) {
      ...
    }
  }
}
...
```

**NOTE**: Be aware that, as the Jenkins jobs are sharing the same PVC, only one Jenkins job can run at a time.