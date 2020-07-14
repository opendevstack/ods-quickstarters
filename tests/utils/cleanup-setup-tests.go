package utils

import (
	b64 "encoding/base64"
	"log"
	"fmt"
	coreUtils "github.com/opendevstack/ods-core/tests/utils"
)

func CleanupAndCreateBitbucketProjectAndRepo(quickstarter string, repoName string) {

	values, err := ReadConfiguration()
	if err != nil {
		log.Fatalf("Error reading ods-core.env: %s", err)
	}

	password, _ := b64.StdEncoding.DecodeString(values["CD_USER_PWD_B64"])

	stdout, stderr, err := RunScriptFromBaseDir("tests/scripts/setup_bitbucket_test_project.sh", []string{
		fmt.Sprintf("--bitbucket=%s", values["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", values["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", coreUtils.PROJECT_NAME),
		fmt.Sprintf("--repository=%s", repoName)},
		[]string{})
	if err != nil {
		fmt.Printf(
			"Execution of `setup_bitbucket_test_project.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
	}

	fmt.Printf("Done\n - cleaned up and created repo: %s\n", repoName)
}
