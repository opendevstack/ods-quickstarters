package utils

import (
	b64 "encoding/base64"
	"fmt"
	"log"
)

func RetrieveSonarScan(projectKey string) (string, error) {

	fmt.Printf("Getting sonar scan for: %s\n", projectKey)

	values, err := ReadConfiguration()
	if err != nil {
		log.Fatalf("Error reading ods-core.env: %s", err)
		return "", err
	}

	sonartoken, _ := b64.StdEncoding.DecodeString(values["SONAR_AUTH_TOKEN_B64"])

	stdout, stderr, err := RunScriptFromBaseDir("tests/scripts/print-sonar-scan-run.sh", []string{
		fmt.Sprintf("%s", sonartoken),
		fmt.Sprintf("%s", values["SONARQUBE_URL"]),
		fmt.Sprintf("%s", projectKey),
	}, []string{})

	if err != nil {
		fmt.Printf(
			"Execution of `tests/scripts/print-sonar-scan-run.sh` failed: \nStdOut: %s\nStdErr: %s\nErr: %s\n",
			stdout,
			stderr,
			err)
		return "", err
	}
	fmt.Printf("Sonar scan result: \n%s\n", stdout)

	return stdout, nil
}
