package docker_plain

import (
	"fmt"
	"testing"
	"path"
	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestJenkinsFile(t *testing.T) {

	values, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatal(err)
	}

	_, filename, _, _ := runtime.Caller(0)
	quickstarterName := path.Dir(filename)
	const componentId = "nodejs"

	// run provision job for docker-plain quickstarter
	utils.cleanupAndCreateBitbucketProjectAndRepo(
		quickstarterName, componentId)

	// run provision job for quickstarter	
	err = utils.RunJenkinsFile(
		"ods-quickstarters",
		values["ODS_BITBUCKET_PROJECT"],
		values["ODS_GIT_REF"],
		coreUtils.PROJECT_NAME,
		fmt.sprintf("%s/Jenkinsfile", quickstarterName),
		coreUtls.PROJECT_NAME_CD,
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
		coreUtils.EnvPair{
			Name:  "GIT_URL_HTTP",
			Value: fmt.Sprintf("%s/%s/%s.git", values["REPO_BASE"], coreUtils.PROJECT_NAME, componentId),
		},
	)
	if err != nil {
		t.Fatal(err)
	}

	// run master build of provisioned quickstarter in project's cd jenkins
	err = utils.RunJenkinsFile(
		componentId,
		coreUtils.PROJECT_NAME,
		"master",
		coreUtils.PROJECT_NAME,
		"Jenkinsfile",
		coreUtils.PROJECT_NAME_CD,
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
	)
	if err != nil {
		t.Fatal(err)
	}

	resourcesInTest := utils.Resources{
		Namespace:         coreUtils.PROJECT_NAME_DEV,
		ImageTags:         []utils.ImageTag{{Name: componentId, Tag: "latest"}},
		BuildConfigs:      []string{componentId},
		DeploymentConfigs: []string{componentId},
		Services:          []string{componentId},
		ImageStreams:      []string{componentId},
	}

	utils.CheckResources(resourcesInTest, t)

}
