# Plain Docker image (docker-plain)

## How to create a custom jenkins-agent out of this docker-plain component
- Remove `odsComponentStageRolloutOpenShiftDeployment(context)` from your `Jenkinsfile`. We only want to build a docker image, not run it outside the pipeline.
- In your `Dockerfile`, replace `FROM alpine:latest` with the ods-jenkins-agent-base image that is available in the OpenDevStack namespace of your cluster, e.g. `FROM docker-registry.default.svc:5000/ods/jenkins-agent-base:latest`.
- Add everything you need in the jenkins-agent to your `Dockerfile`, for examples see the existing agents at [github](https://github.com/opendevstack/ods-quickstarters/tree/master/common/jenkins-agents).
- Commit and push your code to git, this will trigger the pipeline and result in a docker image of your custom jenkins-agent in your cd-namespace.
- Now you can use your custom jenkins-agent by changing the imageStreamTag to `imageStreamTag: '<your_cd_namespace>/<your_custom_jenkins_agent_image_name>:latest'` in the `Jenkinsfile` of the actual application you want to build with your custom new jenkins-agent.