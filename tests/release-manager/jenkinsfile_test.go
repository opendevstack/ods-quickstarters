package release_manager

import (
	b64 "encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"strings"
	"testing"
	"time"

	utils "github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestVerifyOdsQuickstarterProvisionThruProvisionApi(t *testing.T) {
	// cleanup
	projectName := "ODSVERIFY"
	projectCdNamespace := strings.ToLower(projectName) + "-cd"
	componentId := "releasemanager"
	repoName := fmt.Sprintf("%s-%s", strings.ToLower(projectName), componentId)

	golangComponentId := "golang"
	golangRepoName := fmt.Sprintf("%s-%s", strings.ToLower(projectName), golangComponentId)

	// use the api sample script to cleanup
	stages, stderr, err := utils.RunScriptFromBaseDir(
		"tests/scripts/create-project-api.sh",
		[]string{
			"DELETE_COMPONENT",
		}, []string{})

	if err != nil {
		t.Fatalf(
			"Execution of `create-project-api.sh/delete component` for '%s' failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			projectName,
			stages,
			stderr,
			err)
	} else {
		fmt.Printf(
			"Execution of `create-project-api.sh/delete component` for '%s' worked: \nStdOut: %s\n",
			projectName,
			stages)
		time.Sleep(20 * time.Second)
	}

	// cleanup repository
	config, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatalf("Error reading ods-core.env: %s", err)
	}

	password, err := b64.StdEncoding.DecodeString(config["CD_USER_PWD_B64"])
	if err != nil {
		t.Fatalf("Error decoding cd_user password: %s", err)
	}

	stages, stderr, err = utils.RunScriptFromBaseDir("tests/scripts/delete-bitbucket-repo.sh", []string{
		fmt.Sprintf("--bitbucket=%s", config["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", config["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", repoName),
	}, []string{})

	if err != nil {
		t.Fatalf(
			"Execution of `delete-bitbucket-repo.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stages,
			stderr,
			err)
	}

	stages, stderr, err = utils.RunScriptFromBaseDir("tests/scripts/delete-bitbucket-repo.sh", []string{
		fmt.Sprintf("--bitbucket=%s", config["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", config["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", golangRepoName),
	}, []string{})

	if err != nil {
		t.Fatalf(
			"Execution of `delete-bitbucket-repo.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stages,
			stderr,
			err)
	}

	// api sample script - create quickstarter in project
	// the file for this is in golden/create-quickstarter-request.json
	stages, stderr, err = utils.RunScriptFromBaseDir(
		"tests/scripts/create-project-api.sh",
		[]string{
			"PUT",
		}, []string{})

	if err != nil {
		t.Fatalf(
			"Execution of `create-project-api.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stages,
			stderr,
			err)
	} else {
		fmt.Printf("Provision app raw logs:%s\n", stages)
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

	for index, job := range responseExecutionJobsArray {
		responseExecutionJobs := job.(map[string]interface{})

		responseBuildName := responseExecutionJobs["name"].(string)

		fmt.Printf("build name from jenkins: %s\n", responseBuildName)
		responseJenkinsBuildUrl := responseExecutionJobs["url"].(string)
		responseBuildRun := strings.SplitAfter(responseJenkinsBuildUrl, responseBuildName+"/")[1]

		fmt.Printf("build run#: %s\n", responseBuildRun)

		// "name" : "odsverify-cd-ods-qs-dockerplain-master",
		responseBuildClean := strings.Replace(responseBuildName,
			projectCdNamespace+"-", "", 1)

		fullBuildName := fmt.Sprintf("%s-%s", responseBuildClean, responseBuildRun)
		fmt.Printf("full buildName: %s\n", fullBuildName)

		stages, err = utils.GetJenkinsBuildStagesForBuild(projectCdNamespace, fullBuildName)
		if err != nil {
			t.Fatalf("Could not get stages for run: '%s', stdout: '%s', err: %s",
				fullBuildName, stages, err)
		}

		fmt.Printf("Provision pipeline run for %s returned:\n%s", fullBuildName, stages)
		err = utils.VerifyJenkinsStages(fullBuildName, "provisioning", lookupGoldenRecords[index], stages)
		if err != nil {
			t.Fatal(err)
		}
	}

	pipelineName := "mro-pipeline"
	webhookProxySecret := responseI["webhookProxySecret"].(string)
	// start the mro pipeline
	stages, _, err = utils.RunArbitraryJenkinsPipeline(
		projectName,
		repoName,
		projectCdNamespace,
		pipelineName,
		webhookProxySecret)

	if err != nil {
		t.Fatalf("Could not execute pipeline: '%s', stdout: '%s', err: %s",
			pipelineName, stages, err)
	}

	fmt.Printf("Build pipeline run for %s returned:\n%s", componentId, stages)
	err = utils.VerifyJenkinsStages(
		componentId, "build", "golden/jenkins-build-stages-after-provisioning.json", stages)
	if err != nil {
		t.Fatal(err)
	}

	// update metadata.yml with the new repo provisioned in step 1 (be-golang)
	fileToUpload := "../release-manager/files/metadata.yml"
	stages, stderr, err = utils.RunScriptFromBaseDir("tests/scripts/upload-file-to-bitbucket.sh", []string{
		fmt.Sprintf("--bitbucket=%s", config["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", config["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", repoName),
		fmt.Sprintf("--file=%s", fileToUpload),
		fmt.Sprintf("--filename=%s", "metadata.yml"),
	}, []string{})

	if err != nil {
		t.Fatalf(
			"Execution of `upload-file-to-bitbucket.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stages,
			stderr,
			err)
	} else {
		fmt.Printf("Uploaded file %s to %s", fileToUpload, config["BITBUCKET_URL"])
	}

	// run build again ... this time we should get the component built! :D
	stages, buildName, err := utils.RunArbitraryJenkinsPipeline(
		projectName,
		repoName,
		projectCdNamespace,
		pipelineName,
		webhookProxySecret)

	if err != nil {
		t.Fatalf("Could not execute pipeline: '%s', stdout: '%s', err: %s",
			pipelineName, stages, err)
	}

	fmt.Printf("Master (code) 2nd build with golang for %s returned:\n%s", componentId, stages)
	err = utils.VerifyJenkinsStages(
		componentId, "build", "golden/jenkins-build-stages-with-added-repo.json", stages)
	if err != nil {
		t.Fatal(err)
	}

	jenkinsRunIdSplitted := strings.Split(buildName, "-")
	jenkinsRunId := jenkinsRunIdSplitted[len(jenkinsRunIdSplitted)-1]

	artifactsToVerify := []string{
		fmt.Sprintf("DTP-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
		fmt.Sprintf("DTR-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
		fmt.Sprintf("TIP-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
		fmt.Sprintf("TIR-%s-WIP-%s.zip", strings.ToLower(projectName), jenkinsRunId),
	}

	err = utils.VerifyJenkinsRunAttachments(projectCdNamespace, buildName, artifactsToVerify)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Verify Sonar scan of %s ...\n", golangRepoName)
	sonarscan, err := utils.RetrieveSonarScan(golangRepoName)
	if err != nil {
		t.Fatal(err)
	}
	err = utils.VerifySonarScan(golangComponentId, sonarscan)
	if err != nil {
		t.Fatal(err)
	}
}
