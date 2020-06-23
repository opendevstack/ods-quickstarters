package main

import (
	b64 "encoding/base64"
	"log"
	"path"
	"strings"
	"runtime"
	"fmt"
	// coreUtils "github.com/opendevstack/ods-core/tests/utils"
	"github.com/opendevstack/ods-quickstarters/tests/utils"
)

func main() {

	values, err := utils.ReadConfiguration()
	if err != nil {
		log.Fatalf("Error reading ods-core.env: %s", err)
	}

	const projectName = "unitt"
	password, _ := b64.StdEncoding.DecodeString(values["CD_USER_PWD_B64"])
	fmt.Printf("password: %s\n", password)

	quickstarters := map[string]string{
		"docker-plain":"docker-plain-test",
		"be-typescript-express":"nodejs",
	}

	for quickstarter,name := range quickstarters {
		stdout, stderr, err := utils.RunScriptFromBaseDir("tests/scripts/setup_bitbucket_test_project.sh", []string{
			fmt.Sprintf("--bitbucket=%s", values["BITBUCKET_URL"]),
			fmt.Sprintf("--user=%s", values["CD_USER_ID"]),
			fmt.Sprintf("--password=%s", password),
			fmt.Sprintf("--project=%s", projectName),
			fmt.Sprintf("--repository=%s", name)},
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
		buildConfigName := fmt.Sprintf("prov-%s-%s-%s", quickstarter, projectName, strings.ReplaceAll(values["ODS_GIT_REF"], "/", "-")) 

		stdout, stderr, err = utils.RunCommandWithWorkDir("oc", []string{
			"delete",
			"bc",
			"-n", projectName + "-cd",
			buildConfigName}, dir, []string{})
		if err != nil {
			fmt.Printf("Error when deleting provisioning bc %s: %s, %s\n", buildConfigName, err, stdout, stderr)
		}

		// quickstarter master branch build
		buildConfigName = fmt.Sprintf("run-%s-%s-master", name, projectName) 

		stdout, stderr, err = utils.RunCommandWithWorkDir("oc", []string{
			"delete",
			"bc",
			"-n", projectName + "-cd",
			buildConfigName}, dir, []string{})
		if err != nil {
			fmt.Printf("Error when deleting build bc %s: %s, %s\n", buildConfigName, err, stdout, stderr)
		}
	}


	fmt.Printf("Done\n")
}
