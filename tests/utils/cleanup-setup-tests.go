package utils

import (
	"bytes"
	b64 "encoding/base64"
	"fmt"
	"log"
	"os/exec"
	"strings"

	coreUtils "github.com/opendevstack/ods-core/tests/utils"
)

func CleanupAndCreateBitbucketProjectAndRepo(quickstarter string, repoName string) {

	fmt.Printf("-- starting cleanup for repo: %s\n", repoName)

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

	// Delete any built image tags
	imageStreamName := repoName
	stdout, stderr, err = runOcCmd([]string{
		"-n", coreUtils.PROJECT_NAME_DEV,
		"get", "is", imageStreamName,
		"-ojsonpath={.status.tags[*].tag}",
	})
	if err != nil {
		fmt.Printf("(Cleanup) Error when retrieving tags of %s: %s, %s\n", imageStreamName, err, stderr)
	} else {
		fmt.Printf("Found image tags: %s\n", stdout)
		tags := strings.Split(stdout, " ")
		for _, tag := range tags {
			if tag != "latest" { // latest is in use by DeploymentConfig
				stdout, stderr, err = runOcCmd([]string{
					"-n", coreUtils.PROJECT_NAME_DEV,
					"delete",
					fmt.Sprintf("istag/%s:%s", imageStreamName, tag),
				})
				if err != nil {
					fmt.Printf("(Cleanup) Error when deleting image %s:%s: %s, %s\n", imageStreamName, tag, err, stderr)
				} else {
					fmt.Printf("Deleted tag: %s:%s\n", imageStreamName, tag)
				}
			}
		}
	}

	// TODO: Further cleanup (e.g. scaling down deployments?
	// Tricky as we cannot scale to 0, and deleting RC/pod will be "fixed" by Kubernetes

	fmt.Printf("Done\n - cleaned up and created repo: %s\n", repoName)
}

func runOcCmd(args []string) (string, string, error) {
	cmd := exec.Command("oc", args...)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	return string(stdout.Bytes()), string(stderr.Bytes()), err
}
