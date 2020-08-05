package utils

import (
	"bytes"
	b64 "encoding/base64"
	"fmt"
	"os/exec"

	coreUtils "github.com/opendevstack/ods-core/tests/utils"
)

func CleanupAndCreateBitbucketProjectAndRepo(quickstarter string, componentId string) error {

	repoName := fmt.Sprintf("%s-%s", coreUtils.PROJECT_NAME, componentId)

	fmt.Printf("-- starting cleanup for component: %s\n", componentId)

	config, err := ReadConfiguration()
	if err != nil {
		return fmt.Errorf("Error reading ods-core.env: %w", err)
	}

	password, err := b64.StdEncoding.DecodeString(config["CD_USER_PWD_B64"])
	if err != nil {
		return fmt.Errorf("Could not decode cd_user password: %w", err)
	}

	fmt.Printf("-- (re)creating repo: %s\n", repoName)
	stdout, stderr, err := RunScriptFromBaseDir("tests/scripts/setup_bitbucket_test_project.sh", []string{
		fmt.Sprintf("--bitbucket=%s", config["BITBUCKET_URL"]),
		fmt.Sprintf("--user=%s", config["CD_USER_ID"]),
		fmt.Sprintf("--password=%s", password),
		fmt.Sprintf("--project=%s", coreUtils.PROJECT_NAME),
		fmt.Sprintf("--repository=%s", repoName)},
		[]string{})
	if err != nil {
		return fmt.Errorf(
			"Execution of `setup_bitbucket_test_project.sh` failed: \nStdOut: %s\nStdErr: %s\n\nErr: %s",
			stdout,
			stderr,
			err,
		)
	}

	label := fmt.Sprintf("app=%s-%s", coreUtils.PROJECT_NAME, componentId)
	fmt.Printf("-- delete resources labelled with: %s\n", label)
	stdout, stderr, err = runOcCmd([]string{
		"-n", coreUtils.PROJECT_NAME_DEV,
		"delete", "all", "-l", label,
	})
	if err != nil {
		return fmt.Errorf(
			"Could not delete all resources labelled with %s: \nStdOut: %s\nStdErr: %s\n\nErr: %w",
			label,
			stdout,
			stderr,
			err,
		)
	}

	fmt.Printf("-- cleaned up and created repo: %s\n", repoName)
	return nil
}

func runOcCmd(args []string) (string, string, error) {
	cmd := exec.Command("oc", args...)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	return string(stdout.Bytes()), string(stderr.Bytes()), err
}
