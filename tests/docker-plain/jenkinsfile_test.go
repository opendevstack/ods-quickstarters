package docker_plain

import (
	"encoding/json"
	"fmt"
	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
	"log"
	"net/http"
	"strings"
	"testing"
)

func TestJenkinsFile(t *testing.T) {

	values, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatal(err)
	}

	const component_id = "docker-plain-test"
	err = utils.RunJenkinsFile(
		"ods-quickstarters",
		"opendevstack",
		"cicdtests",
		coreUtils.PROJECT_NAME,
		"docker-plain/Jenkinsfile",
		"unitt-cd",
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: component_id,
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
		component_id,
		"unitt",
		"master",
		coreUtils.PROJECT_NAME,
		"Jenkinsfile",
		"unitt-cd",
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: component_id,
		},
	)
	if err != nil {
		t.Fatal(err)
	}

	resourcesInTest := utils.Resources{
		Namespace:         coreUtils.PROJECT_NAME_TEST,
		ImageTags:         []utils.ImageTag{{Name: component_id, Tag: "latest"}},
		BuildConfigs:      []string{component_id},
		DeploymentConfigs: []string{component_id},
		Services:          []string{component_id},
		ImageStreams:      []string{component_id},
	}

	utils.CheckResources(resourcesInTest, t)

	stdout, stderr, err := coreUtils.RunCommand("docker", []string{"exec", "mockbucket", "sh", "-c", "cd /scm/unitt/docker-plain-test.git && git rev-parse HEAD"}, []string{})
	if err != nil {
		t.Fatalf("Docker exec failed:%s\nStdOut: %s\nStdErr: %s", err, stdout, stderr)
	}

	client := &http.Client{}
	url := fmt.Sprintf("http://%s/rest/build-status/1.0/commits/%s", values["BITBUCKET_HOST"], strings.TrimSuffix(stdout, "\n"))
	request, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatal(err)
	}
	request.SetBasicAuth(values["CD_USER_ID"], values["CD_USER_PWD"])
	response, err := client.Do(request)
	if err != nil {
		log.Fatal(err)
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
