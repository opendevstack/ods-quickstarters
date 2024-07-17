# TODO
Can we adapt NOTES.txt to display some deployed resources and other important information for release documentation? Do we need it?

- helm linting preps, hence to add values schema validation in the chart together with the values.yaml
    - add a test for helm lint
        - future add as a Jenkins shared lib stage
        - now either we do it as an added manually in the jenkinsfiles or documented and test locally
        - make use of it on the github actions when PRs on quickstarters (reuse max as possible)
- we will move to values.yaml
    - [X] the probes
    - [x] the affinity (missing labels now and some additions required)
    - [x] the route (with timeout values and example for ACME usage)
    - [x] rolling update strategy?
- [X] remove provisioning resources creation -> get rid odsQuickstarterStageCreateOpenShiftResources
- jenkinsfile with values.env.yaml ready, so we will provide all the env values too: Different replicaCount + ingress hosts
- [X] update test-conection.yaml with better image (to not suffer dockerhub rate limiting)
- [X] golden tests do not check anymore imagetags nor deploymentconfigs
- [X] Test ingress on Openshift without hostname -> is there a generated one? NO -> host value is required but tls can be left empty now with default OpenShift TLS (See ingress.yaml and values.yaml). host value is required as ingress approach is a rules based system.
- [] Make ingress more standard helm (e.g. list of hosts) -> Sebastian
- start defining howtos/FAQS we detect on the way (goal to keep simple the chart but to show how to improve it and have good practises) bitnami examples (more elaborated affinity, ...)


- example of chart dependency
- example of configmap and secret
- example of secret resource management in code
- add support for extra secret operator

Later
- with the common folder with tpl files we provide a more clean and fitting approach for us
- create a new pipeline step provisioning that copies over .tpl files required from common
- creation of template files folder in common, so we try to centralise the chart creation and maintenance from one place (as it is done already with openshift templates/tailor)

Decisions:
- To stay close to default helm templates: Remove the Values.componentId and use chart.fullname instead -> Otherwise breaks DEV + PREVIEW. Chart.Name should be the source for componentId. If we want to automate -> template the Chart.yaml on provisioning

Shared library ToDo's:
- Match required labels (app)
- Review helm install command
- Release manager image checks
- Agree if helm install requires overwritting values on image (see helm notes and deployment, and values.yaml)
