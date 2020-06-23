package docker_plain

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestJenkinsFile(t *testing.T) {

	values, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatal(err)
	}

	const componentId = "docker-plain-test"
	err = utils.RunJenkinsFile(
		"ods-quickstarters",
		"opendevstack",
		values["ODS_GIT_REF"],
		coreUtils.PROJECT_NAME,
		"docker-plain/Jenkinsfile",
		"unitt-cd",
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
		coreUtils.EnvPair{
			Name:  "GIT_URL_HTTP",
			Value: fmt.Sprintf("%s/unitt/docker-plain-test.git", values["REPO_BASE"]),
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

	client := &http.Client{Timeout: 10 * time.Second}
	url := fmt.Sprintf("http://%s/rest/build-status/1.0/commits/%s", values["BITBUCKET_HOST"], strings.TrimSuffix(stdout, "\n"))
	request, err := http.NewRequest("GET", url, nil)
	if err != nil {
		t.Fatal(err)
	}
	request.SetBasicAuth(values["CD_USER_ID"], values["CD_USER_PWD"])
	response, err := client.Do(request)
	if err != nil {
		t.Fatal(err)
	}

	commitStatus := utils.CommitStatus{}
	err = json.NewDecoder(response.Body).Decode(&commitStatus)
	if err != nil {
		t.Fatal(err)
	}

	if commitStatus.State != "SUCCESSFUL" {
		t.Error("The commit status should have been SUCCESSFUL")
	}

}
