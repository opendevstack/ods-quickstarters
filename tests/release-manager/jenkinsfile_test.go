package release_manager

import (
	"testing"
	"io/ioutil"
	"fmt"
	"strings"
	"encoding/json"
	"time"
	utils "github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestVerifyOdsQuickstarterProvisionThruProvisionApi(t *testing.T) {
	// cleanup
	projectName := "ODSVERIFY"
	projectCdNamespace := strings.ToLower(projectName) + "-cd"
	componentId := "releasemanager"

	// use the api sample script to cleanup
	stdout, stderr, err := utils.RunScriptFromBaseDir(
		"tests/scripts/create-project-api.sh",
		[]string{
			"DELETE_COMPONENT",
		}, []string{})

	if err != nil {
		fmt.Printf(
			"Execution of `create-project-api.sh/delete component` for '%s' failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			projectName,
			stdout,
			stderr,
			err)
	} else {
		fmt.Printf(
			"Execution of `create-project-api.sh/delete component` for '%s' worked: \nStdOut: %s\n",
			projectName,
			stdout)
		time.Sleep(20 * time.Second)
	}
	
	// api sample script - create quickstarter in project
	// the file for this is in golden/create-quickstarter-request.json
	stdout, stderr, err = utils.RunScriptFromBaseDir(
		"tests/scripts/create-project-api.sh",
		[]string{
			"PUT",
		}, []string{})

	if err != nil {
		t.Fatalf(
			"Execution of `create-project-api.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
	} else {
		fmt.Printf("Provision app raw logs:%s\n", stdout)
	}

	// get the (json) response from the script created file
	log, err := ioutil.ReadFile("response.txt")
	if err != nil {
		t.Fatalf("Could not read response file?!, %s\n", err)
	} else {
		fmt.Printf("Provision results: %s\n", string(log))
	}
	
	var responseI map[string]interface{}
	err = json.Unmarshal(log, &responseI)
	if err != nil {
		t.Fatalf("Could not parse json response: %s, err: %s",
			string(log), err)
	}
	
	responseProjectName := responseI["projectName"].(string)
	if projectName != responseProjectName {
		t.Fatalf("Project names don't match - expected: %s real: %s",
			projectName, responseProjectName) 
	}
	
	responseExecutionJobsArray := responseI["lastExecutionJobs"].([]interface{})
	responseExecutionJobs := responseExecutionJobsArray[len(responseExecutionJobsArray) - 1].
		(map[string]interface{})
	responseBuildName := responseExecutionJobs["name"].(string)
	webhookProxySecret := responseI["webhookProxySecret"].(string)

	fmt.Printf("build name from jenkins: %s\n", responseBuildName)
	responseJenkinsBuildUrl := responseExecutionJobs["url"].(string)
	responseBuildRun := strings.SplitAfter(responseJenkinsBuildUrl, responseBuildName + "/")[1]
	
	fmt.Printf("build run#: %s\n", responseBuildRun)
	
	// "name" : "odsverify-cd-ods-qs-dockerplain-master",
	
	responseBuildClean := strings.Replace(responseBuildName,
		projectCdNamespace + "-", "", 1)

	fullBuildName := fmt.Sprintf("%s-%s", responseBuildClean, responseBuildRun)
	fmt.Printf("full buildName: %s\n", fullBuildName)

	stdout, err = utils.GetJenkinsBuildStagesForBuild (projectCdNamespace, fullBuildName)
	if err != nil {
		t.Fatalf("Could not get stages for run: '%s', stdout: '%s', err: %s",
			fullBuildName, stdout, err)
	}
		
	// verify provision jenkins stages - against golden record
	expected, err := ioutil.ReadFile("golden/create-quickstarter-response.json")
	if err != nil {
		t.Fatal(err)
	}
	
	if stdout != string(expected) {
		t.Fatalf("prov run - records don't match -golden:\n'%s'\n-jenkins response:\n'%s'",
			string(expected), stdout)
	}
	
	pipelineName := "mro-pipeline"
	stdout, err = utils.RunArbitraryJenkinsPipeline(
		projectName,
		fmt.Sprintf("%s-%s", strings.ToLower(projectName), componentId),
		projectCdNamespace,
		pipelineName,
		webhookProxySecret)
	
	if err != nil {
		t.Fatalf("Could not execute pipeline: '%s', stdout: '%s', err: %s",
			pipelineName, stdout, err)
	}
}
