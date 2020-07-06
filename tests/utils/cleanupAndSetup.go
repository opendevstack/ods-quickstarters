package utils

import (
	b64 "encoding/base64"
	"log"
	"path"
	"strings"
	"runtime"
	"fmt"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
)

func cleanupAndCreateBitbucketProjectAndRepo(projectName string, quickstarter string, repoName string) error {

	values, err := utils.ReadConfiguration()
	if err != nil {
		log.Fatalf("Error reading ods-core.env: %s", err)
	}

	const projectName = "unitt"
	password, _ := b64.StdEncoding.DecodeString(values["CD_USER_PWD_B64"])

	stdout, stderr, err := utils.RunScriptFromBaseDir("tests/scripts/setup_bitbucket_test_project.sh", []string{
		fmt.Sprintf("--bitbucket=%s", values["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", values["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", projectName),
		fmt.Sprintf("--repository=%s", repoName)},
		[]string{})
	if err != nil {
		fmt.Printf(
			"Execution of `setup_bitbucket_test_project.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
	}

	_, filename, _, _ := runtime.Caller(0)
	dir := path.Dir(filename)

	// provision build config
	buildConfigName := fmt.Sprintf("prov-%s-%s-%s", 
		quickstarter, projectName, strings.ReplaceAll(values["ODS_GIT_REF"], "/", "-")) 

	stdout, stderr, err = utils.RunCommandWithWorkDir("oc", []string{
		"delete",
		"bc",
		"-n", projectName + "-cd",
		buildConfigName}, dir, []string{})
	if err != nil {
		fmt.Printf("Error when deleting provisioning bc %s: %s, %s\n", 
			buildConfigName, err, stdout, stderr)
	}

	// quickstarter master branch build
	buildConfigName = fmt.Sprintf("run-%s-%s-master", repoName, projectName) 

	stdout, stderr, err = utils.RunCommandWithWorkDir("oc", []string{
		"delete",
		"bc",
		"-n", projectName + "-cd",
		buildConfigName}, dir, []string{})
	if err != nil {
		fmt.Printf("Error when deleting build bc %s: %s, %s\n", buildConfigName, err, stdout, stderr)
	}

	fmt.Printf("Done\n - created repo:%s", repoName)
}
