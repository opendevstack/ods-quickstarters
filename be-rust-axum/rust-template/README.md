# {{project-name}} - from the OpenDevStack Rust QuickStarter (be-rust-axum)

The official OpenDevStack documentation for this QuickStarter can be found [here](https://www.opendevstack.org/ods-documentation/opendevstack/latest/quickstarters/be-rust-axum.html).

Check also the official docs of the [Jenkins Rust Agent](https://www.opendevstack.org/ods-documentation/opendevstack/latest/jenkins-agents/rust.html) this Quickstarter makes use of. There you can see the setup and tools it provides.

## Pre-commit hooks

This project uses [pre-commit](https://pre-commit.com).
[Install it](https://pre-commit.com/#install) and apply the already provided pre-commit hooks (see `.pre-commit-config.yaml`) configurations:

```bash
pre-commit install
```

The provided pre-commit hooks are:
- gitleaks (check for secrets)
- cargo-deny (dependency auditing, see/update `deny.toml` config file)
- cargo-fmt (formatter, see/update `rustfmt.toml` config file)
- cargo-clippy (linter)

**NOTE**: the cargo hooks also run in Jenkins CICD, but cargo deny is disabled by default, see Jenkinsfile.

## Adding caching in your CICD

One can improve the build pipeline time by implementing a caching mechanism as shown next:

1. Create a PVC in your `foo-cd` OpenShift CICD ODS project (e.g.: call it `cargo-cache`).
2. Replace the `odsComponentPipeline` context and stages definitions from:

    ```groovy
    odsComponentPipeline(
      imageStreamTag: 'ods/jenkins-agent-rust:4.x',
      branchToEnvironmentMapping: [
        'master': 'dev',
        // 'release/': 'test'
      ]
    ) { context ->
    ...
      stageCI(context)
    ...
      stageBuild(context)
    ...
      def stageBuild(def context) {
    ...
      def stageCI(def context) {
    ...
        sh "cp -r target/release/${context.componentId} docker/app"
    ...
        cp -r target/llvm-cov/html/ build/test-results/coverage
    ```

   to:

    ```groovy
    def dockerRegistry
    def cachePath
    node {
      dockerRegistry = env.DOCKER_REGISTRY
      cachePath = '/home/jenkins/.cargo/cache'
    }

    odsComponentPipeline(
      podVolumes: [
        persistentVolumeClaim(mountPath: "${cachePath}", claimName: "cargo-cache", readOnly: false)
      ],
      podContainers: [
        containerTemplate(
          name: 'jnlp',
          image: "${dockerRegistry}/ods/jenkins-agent-rust:4.x",
          workingDir: '/tmp',
          envVars: [
            envVar(key: 'CARGO_TARGET_DIR', value: "${cachePath}"),
            envVar(key: 'CARGO_INCREMENTAL', value: 'true')
          ],
          resourceRequestCpu: '750m',
          resourceLimitCpu: '1500m',
          resourceRequestMemory: '1Gi',
          resourceLimitMemory: '1.5Gi',
          alwaysPullImage: true,
          args: '${computer.jnlpmac} ${computer.name}'
        ),
      ],
      branchToEnvironmentMapping: [
        'master': 'dev',
        // 'release/': 'test'
      ]
    ) { context ->
    ...
      stageCI(context, cachePath)
    ...
      stageBuild(context, cachePath)
    ...
      def stageBuild(def context, def cachePath) {
    ...
      def stageCI(def context, def cachePath) {
    ...
        sh "cp -r ${cachePath}/release/${context.componentId} docker/app"
    ...
        cp -r ${cachePath}/llvm-cov/html/ build/test-results/coverage
    ```

**NOTE**: Be aware that, as the Jenkins jobs are sharing the same PVC, only one Jenkins job can run at a time.
