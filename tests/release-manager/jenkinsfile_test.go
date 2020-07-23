package release_manager

import (
	"testing"
	"io/ioutil"
	"fmt"
	"strings"
	"encoding/json"
	"time"
	b64 "encoding/base64"
	"log"
	utils "github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestVerifyOdsQuickstarterProvisionThruProvisionApi(t *testing.T) {
	// cleanup
	projectName := "ODSVERIFY"
	projectCdNamespace := strings.ToLower(projectName) + "-cd"
	componentId := "releasemanager"
	golangComponentId := "golang"

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

	// cleanup repository
	values, err := utils.ReadConfiguration()
	if err != nil {
		log.Fatalf("Error reading ods-core.env: %s", err)
	}

	password, _ := b64.StdEncoding.DecodeString(values["CD_USER_PWD_B64"])

	stdout, stderr, err = utils.RunScriptFromBaseDir("tests/scripts/delete-bitbucket-repo.sh", []string{
		fmt.Sprintf("--bitbucket=%s", values["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", values["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", fmt.Sprintf("%s-%s", strings.ToLower(projectName), componentId)),
	},[]string{})
	
	if err != nil {
		fmt.Printf(
			"Execution of `delete-bitbucket-repo.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
	}

	stdout, stderr, err = utils.RunScriptFromBaseDir("tests/scripts/delete-bitbucket-repo.sh", []string{
		fmt.Sprintf("--bitbucket=%s", values["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", values["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", fmt.Sprintf("%s-%s", strings.ToLower(projectName), golangComponentId)),
	},[]string{})
	
	if err != nil {
		fmt.Printf(
			"Execution of `delete-bitbucket-repo.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
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
	
	lookupGoldenRecords := []string{
		"golden/create-quickstarter-response.json",
		"../be-golang-plain/golden/jenkins-provision-stages.json",
	}
	
	jenkinsBuildId := "1"
	
	for index, job := range responseExecutionJobsArray {
		responseExecutionJobs := job.(map[string]interface{})

		responseBuildName := responseExecutionJobs["name"].(string)
	
		fmt.Printf("build name from jenkins: %s\n", responseBuildName)
		responseJenkinsBuildUrl := responseExecutionJobs["url"].(string)
		responseBuildRun := strings.SplitAfter(responseJenkinsBuildUrl, responseBuildName + "/")[1]
		
		fmt.Printf("build run#: %s\n", responseBuildRun)
		jenkinsBuildId = responseBuildRun
		
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
		expected, err := ioutil.ReadFile(lookupGoldenRecords[index])
		if err != nil {
			t.Fatal(err)
		}
		
		if stdout != string(expected) {
			t.Fatalf("prov run : %s - records don't match -golden:\n'%s'\n-jenkins response:\n'%s'",
				fullBuildName, string(expected), stdout)
		}	
	}
	
	pipelineName := "mro-pipeline"
	webhookProxySecret := responseI["webhookProxySecret"].(string)
	// start the mro pipeline
	stdout, _, err = utils.RunArbitraryJenkinsPipeline(
		projectName,
		fmt.Sprintf("%s-%s", strings.ToLower(projectName), componentId),
		projectCdNamespace,
		pipelineName,
		webhookProxySecret)
	
	if err != nil {
		t.Fatalf("Could not execute pipeline: '%s', stdout: '%s', err: %s",
			pipelineName, stdout, err)
	} 
	
	fmt.Printf("Master (code) build for %s returned:\n%s", componentId, stdout)

	// verify run and build jenkins stages - against golden record
	expected, err := ioutil.ReadFile("golden/jenkins-build-stages-after-provisioning.json")
	if err != nil {
		t.Fatal(err)
	}

	if stdout != string(expected) {
		t.Fatalf("Actual jenkins stages from build run: %s don't match -golden:\n'%s'\n-jenkins response:\n'%s'",
			componentId, string(expected), stdout)
	}

	// update metadata.yml with the new repo provisioned in step 1 (be-golang)
	stdout, stderr, err = utils.RunScriptFromBaseDir("tests/scripts/upload-file-to-bitbucket.sh", []string{
		fmt.Sprintf("--bitbucket=%s", values["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", values["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", fmt.Sprintf("%s-%s", strings.ToLower(projectName), componentId)),
		fmt.Sprintf("--file=%s", "../release-manager/files/metadata.yml"),
		fmt.Sprintf("--filename=%s", "metadata.yml"),
	},[]string{})
	
	if err != nil {
		t.Fatalf(
			"Execution of `upload-file-to-bitbucket.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
	}

	// run build again ... this time we should get the component built! :D
	stdout, buildName, err := utils.RunArbitraryJenkinsPipeline(
		projectName,
		fmt.Sprintf("%s-%s", strings.ToLower(projectName), componentId),
		projectCdNamespace,
		pipelineName,
		webhookProxySecret)
	
	if err != nil {
		t.Fatalf("Could not execute pipeline: '%s', stdout: '%s', err: %s",
			pipelineName, stdout, err)
	} 
	
	fmt.Printf("Master (code) 2nd build with golang for %s returned:\n%s", componentId, stdout)

	// verify run and build jenkins stages - against golden record
	expected, err = ioutil.ReadFile("golden/jenkins-build-stages-with-added-repo.json")
	if err != nil {
		t.Fatal(err)
	}

	if stdout != string(expected) {
		t.Fatalf("Actual jenkins stages from build run: %s don't match -golden:\n'%s'\n-jenkins response:\n'%s'",
			componentId, string(expected), stdout)
	}

	jenkinsRunIdSplitted := strings.Split(buildName, "-")
	jenkinsRunId := jenkinsRunIdSplitted[len(jenkinsRunIdSplitted)-1]

	artifactsToVerify := []string{
		fmt.Sprintf("DTP-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
		fmt.Sprintf("DTR-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
		fmt.Sprintf("TIP-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
		fmt.Sprintf("TIR-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
	}
	
	// verify that we can retrieve artifacts from the RM jenkins run
	for _, document := range artifactsToVerify {
		stdout, stderr, err = utils.RunScriptFromBaseDir(
			"tests/scripts/get-artifact-from-jenkins-run.sh",
			[]string{
				buildName,
				projectCdNamespace,
				document,
			}, []string{})
	
		if err != nil {
			t.Fatalf("Could not execute tests/scripts/get-artifact-from-jenkins-run.sh\n - err:%s\nout:%s\nstderr:%s",
				err, stdout, stderr)
		}
	}
	
	// sonar scan check
	sonarscan, err := utils.RetrieveSonarScan(
		fmt.Sprintf("%s-%s", projectCdNamespace, golangComponentId))

	if err != nil {
		t.Fatal(err)
	}

	// verify sonar scan - against golden be golang record
	expected, err = ioutil.ReadFile("../be-golang-plain/golden/sonar-scan.json")
	if err != nil {
		t.Fatal(err)
	}

	if sonarscan != string(expected) {
		t.Fatalf("Actual sonar scan for golang mro run: %s doesn't match -golden:\n'%s'\n-sonar response:\n'%s'",
			golangComponentId, string(expected), sonarscan)
	}

}
