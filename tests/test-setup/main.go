package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	mockbucket "github.com/opendevstack/mockbucket/api"
	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	err := coreUtils.RemoveAllTestOCProjects()
	err = utils.RunJenkinsFile("ods-core", "opendevstack", "cicdtests", coreUtils.PROJECT_NAME, "create-projects/Jenkinsfile", "prov-cd")
	if err != nil {
		log.Fatalf("Error running JenkinsFile : %s", err)
	}

	fmt.Printf("Project %s is create to support testing. Be sure not to delete the namespaces '%s', '%s' and '%s' during your tests ",
		coreUtils.PROJECT_NAME,
		coreUtils.PROJECT_NAME_CD,
		coreUtils.PROJECT_NAME_TEST,
		coreUtils.PROJECT_NAME_DEV)

	values, err := utils.ReadConfiguration()
	if err != nil {
		log.Fatalf("Error reading ods-core.env: %s", err)
	}

	repository := mockbucket.Repository{
		Name: "docker-plain-test",
	}
	repositoryJson, err := json.Marshal(repository)
	if err != nil {
		log.Fatal(err)
	}
	client := &http.Client{}
	url := fmt.Sprintf("http://%s/rest/api/1.0/projects/%s/repos", values["BITBUCKET_HOST"], coreUtils.PROJECT_NAME)
	request, err := http.NewRequest("POST", url, bytes.NewBuffer(repositoryJson))
	if err != nil {
		log.Fatal(err)
	}
	request.SetBasicAuth(values["CD_USER_ID"], values["CD_USER_PWD"])
	response, err := client.Do(request)
	if err != nil {
		log.Fatal(err)
	}

	bodyBytes, err := ioutil.ReadAll(response.Body)
	if err != nil {
		log.Fatal(err)
	}

	if response.StatusCode != http.StatusCreated {
		log.Fatal(string(bodyBytes))
	} else {
		log.Print(string(bodyBytes))
	}
}
