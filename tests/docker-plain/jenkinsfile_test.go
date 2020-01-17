package docker_plain

import (
	"encoding/json"
	"fmt"
	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
	"net/http"
	"strings"
	"testing"
	"time"
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
		"cicdtests",
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
		Namespace:         coreUtils.PROJECT_NAME_TEST,
		ImageTags:         []utils.ImageTag{{Name: componentId, Tag: "latest"}},
		BuildConfigs:      []string{componentId},
		DeploymentConfigs: []string{componentId},
		Services:          []string{componentId},
		ImageStreams:      []string{componentId},
	}

	utils.CheckResources(resourcesInTest, t)

	stdout, stderr, err := coreUtils.RunCommand("docker", []string{"exec", "mockbucket", "sh", "-c", "cd /scm/unitt/docker-plain-test.git && git rev-parse HEAD"}, []string{})
	if err != nil {
		t.Fatalf("Docker exec failed:%s\nStdOut: %s\nStdErr: %s", err, stdout, stderr)
	}

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
