package docker_plain

import (
	"fmt"
	"testing"
	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestJenkinsFile(t *testing.T) {

	values, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatal(err)
	}

	const componentId = "nodejs"

	// buildConfigName := fmt.Sprintf("ods-corejob-docker-plain-unitt-%s", strings.ReplaceAll(values["ODS_GIT_REF"], "/", "-")) 
	// run provision job for docker-plain quickstarter
	err = utils.RunJenkinsFile(
		"ods-quickstarters",
		"opendevstack",
		values["ODS_GIT_REF"],
		coreUtils.PROJECT_NAME,
		"be-typescript-express/Jenkinsfile",
		"unitt-cd",
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
		coreUtils.EnvPair{
			Name:  "GIT_URL_HTTP",
			Value: fmt.Sprintf("%s/unitt/nodejs.git", values["REPO_BASE"]),
		},
	)
	if err != nil {
		t.Fatal(err)
	}

	err = utils.RunJenkinsFile(
		componentId,
		"unitt",
		"master",
		coreUtils.PROJECT_NAME,
		"Jenkinsfile",
		"unitt-cd",
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