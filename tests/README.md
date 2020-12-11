# ODS Quickstarters - tests

All tests of quickstarters follow the same scheme:

1. a single test file, named `jenkinsfile_test.go`, inside a folder named exactly as the `quickstarter type` (e.g. be-golang-plain) - which provisions a quickstarter, and then runs the `jenkinsfile` of the newly created component to build and deploy it
1. a directory `golden` housing golden records for the jenkins stages of the two runs (provision and build), as well as from sonarqube to verify the actual responses against
1. a quickstarter test always provisions the component into an ODS created namespace called `unitt` - which is created by the tests in [ods-core](https://github.com/opendevstack/ods-core/tree/master/tests). So those tests must be run first, thru `make test` in `ods-core/tests`

**ATTENTION**: For the tests to work the `cd_user` configured in `ods-configuration/ods-core.env` **MUST** have rights to create and manage a bitbucket project

## Anatomy of a quickstarter test
Lets look at a single test in detail - in this case the one for [spring boot](be-java-springboot/jenkinsfile_test.go)

1. Create the bitbucket repository for the quickstarter (and bitbucket project if needed)
```
	// cleanup and create bb resources for this test
	utils.CleanupAndCreateBitbucketProjectAndRepo(
		quickstarterName, componentId)
```

2. Start the provisioning of a quickstarter thru the webhook proxy

```
	// run provision job for quickstarter in project's cd jenkins
	stages, err := utils.RunJenkinsFile(
		"ods-quickstarters", // the repository 
		values["ODS_BITBUCKET_PROJECT"], 
		values["ODS_GIT_REF"], // branch on ods-quickstarters
		coreUtils.PROJECT_NAME,
		fmt.Sprintf("%s/Jenkinsfile", quickstarterName),
		coreUtils.PROJECT_NAME_CD,
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
		coreUtils.EnvPair{
			Name:  "GIT_URL_HTTP",
			Value: fmt.Sprintf("%s/%s/%s.git", values["REPO_BASE"], coreUtils.PROJECT_NAME, componentId),
		},
	)
```

3. Verify expected stages from the `golden` [provisioning record](be-java-springboot/golden/jenkins-provision-stages.json) against the jenkins created `stages`

4. Trigger a jenkins build run instance (for the provisioned component)

```
	// run master build of provisioned quickstarter in project's cd jenkins
	stages, err = utils.RunJenkinsFile(
		repoName,
		coreUtils.PROJECT_NAME,
		"master", // branch
		coreUtils.PROJECT_NAME,
		"Jenkinsfile",
		coreUtils.PROJECT_NAME_CD,
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
	)
```

5. Verify expected stages from the `golden` [run / build record](be-java-springboot/golden/jenkins-build-stages.json) against the response `stages`

5. Verify the created OCP artifacts, and if pods / deployments are available - thru tailor diff

```
	resourcesInTest := coreUtils.Resources{
		Namespace:         coreUtils.PROJECT_NAME_DEV,
		ImageTags:         []coreUtils.ImageTag{{Name: componentId, Tag: "latest"}},
		BuildConfigs:      []string{componentId},
		DeploymentConfigs: []string{componentId},
		Services:          []string{componentId},
		ImageStreams:      []string{componentId},
	}
```

All necessary utils, except for [scripts](scripts) are housed in [ods-core/tests](https://github.com/opendevstack/ods-core/tree/master/tests/utils)

## Running the tests
To run the quickstarter tests, some prerequisites are required, e.g. go, oc, jq, etc. You could either install them in your local machine and just run `make test` in [this](Makefile) directory or, use a Docker image that ships all the required dependencies.

### Building the Docker image

The assets to build the Docker image are in the [ods-quickstarters-tests-runner](ods-quickstarters-tests-runner) directory.

If you're running behind a corporate proxy, update **both** the [Dockerfile](ods-quickstarters-tests-runner/Dockerfile) and [entrypoint.sh](ods-quickstarters-tests-runner/entrypoint.sh) files to configure them properly by setting the `HTTP_PROXY`, `HTTPS_PROXY`, ... values accordingly.

Next, make sure you're in the [ods-quickstarters-tests-runner](ods-quickstarters-tests-runner) directory where the [Dockerfile](ods-quickstarters-tests-runner/Dockerfile)(Dockerfile) is present to build the image as follows:

```cli
docker build --tag ods-quickstarters-tests-runner .
```

### Run the tests with Docker

To run the quickstarter tests using Docker, you need to be in the **umbrella directory**. This is a directory holding all ODS respositories, for instance:

```cli
UMBRELLA_DIR=~/opendevstack
```

When running the image, we will use a bind mount, where the directories under the umbrella directory on the host machine is mounted into the `/work` directory within the container.

To run **all** the tests, just execute:

```cli
cd $UMBRELLA_DIR

docker run --rm -it \
    -v $(pwd):/work \
    ods-quickstarters-tests-runner
```

If wanted, you also have the option to run a **specific** test instead of all of them. For that, use the `-q` or `--quickstarter` argument to specify which quickstarter you want to run.

For instance, to run the `be-golang-plain` quickstarter test, execute:

```cli
docker run --rm -it \
    -v $(pwd):/work \
    ods-quickstarters-tests-runner \
    -q be-golang-plain
```
