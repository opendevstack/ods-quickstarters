package utils

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
	"time"

	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	v1 "github.com/openshift/api/build/v1"
	buildClientV1 "github.com/openshift/client-go/build/clientset/versioned/typed/build/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func RunJenkinsFile(repository string, repositoryProject string, branch string, projectName string, jenkinsFile string, jenkinsNamespace string, envVars ...coreUtils.EnvPair) (string, error) {
	values, err := ReadConfiguration()
	if err != nil {
		return "", err
	}

	request := coreUtils.RequestBuild{
		Repository: repository,
		Branch:     branch,
		Project:    repositoryProject,
		Env: append([]coreUtils.EnvPair{
			{
				Name:  "PROJECT_ID",
				Value: projectName,
			},
			{
				Name:  "CD_USER_TYPE",
				Value: "general",
			},
			{
				Name:  "CD_USER_ID_B64",
				Value: values["CD_USER_ID_B64"],
			},
			{
				Name:  "PIPELINE_TRIGGER_SECRET",
				Value: values["PIPELINE_TRIGGER_SECRET_B64"],
			},
			{
				Name:  "ODS_GIT_REF",
				Value: values["ODS_GIT_REF"],
			},
			{
				Name:  "ODS_IMAGE_TAG",
				Value: values["ODS_IMAGE_TAG"],
			},
		}, envVars...),
	}

	body, err := json.Marshal(request)
	if err != nil {
		return "", fmt.Errorf("Could not marshal json: %s", err)
	}

	jenkinsFilePath := strings.Split(jenkinsFile, "/")
	pipelineNamePrefix := strings.ToLower(jenkinsFilePath[0])
	pipelineJobName := "prov"
	if len(jenkinsFilePath) == 1 {
		pipelineNamePrefix = repository
		pipelineJobName = "run"
	}

	pipelineName := fmt.Sprintf("%s-%s-%s", pipelineJobName, pipelineNamePrefix, projectName)

	fmt.Printf("Starting pipeline %s\n", pipelineName)

	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}
	url := fmt.Sprintf("https://webhook-proxy-%s%s/build?trigger_secret=%s&jenkinsfile_path=%s&component=%s",
		jenkinsNamespace,
		values["OPENSHIFT_APPS_BASEDOMAIN"],
		values["PIPELINE_TRIGGER_SECRET"],
		jenkinsFile,
		pipelineName)
	response, err := http.Post(
		url,
		"application/json",
		bytes.NewBuffer(body))

	defer response.Body.Close()

	bodyBytes, err := ioutil.ReadAll(response.Body)

	fmt.Printf("Pipeline: %s\n, response: %s\n", pipelineName, string(bodyBytes))

	if response.StatusCode >= http.StatusAccepted {
		bodyBytes, err := ioutil.ReadAll(response.Body)
		if err != nil {
			return "", err
		}
		return "", fmt.Errorf("Could not post to pipeline: %s (%s) - response: %d, body: %s",
			pipelineName, url, response.StatusCode, string(bodyBytes))
	}

	var responseI map[string]interface{}
	err = json.Unmarshal(bytes.Split(bodyBytes, []byte("\n"))[0], &responseI)
	if err != nil {
		return "", fmt.Errorf("Could not parse json response: %s, err: %s",
			string(bodyBytes), err)
	}

	metadataAsMap := responseI["metadata"].(map[string]interface{})
	buildName := metadataAsMap["name"].(string)
	fmt.Printf("Pipeline: %s, Buildname from response: %s\n",
		pipelineName, buildName)

	config, err := coreUtils.GetOCClient()
	if err != nil {
		return "", fmt.Errorf("Error creating OC config: %s", err)
	}

	buildClient, err := buildClientV1.NewForConfig(config)
	if err != nil {
		return "", fmt.Errorf("Error creating Build client: %s", err)
	}

	time.Sleep(10 * time.Second)
	build, err := buildClient.Builds(jenkinsNamespace).Get(buildName, metav1.GetOptions{})
	count := 0
	// especially provision builds with CLIs take longer ...
	max := 40
	for (err != nil || build.Status.Phase == v1.BuildPhaseNew || build.Status.Phase == v1.BuildPhasePending || build.Status.Phase == v1.BuildPhaseRunning) && count < max {
		build, err = buildClient.Builds(jenkinsNamespace).Get(buildName, metav1.GetOptions{})
		time.Sleep(20 * time.Second)
		if err != nil {
			fmt.Printf("Err Build: %s is still not available, %s\n", buildName, err)
			// try to refresh the client - sometimes the token does expire...
			config, err = coreUtils.GetOCClient()
			if err != nil {
				fmt.Printf("Error creating OC config: %s", err)
			} else {
				buildClient, err = buildClientV1.NewForConfig(config)
				if err != nil {
					fmt.Printf("Error creating Build client: %s", err)
				}
			}
		} else {
			fmt.Printf("Waiting for build to complete: %s. Current status: %s\n", buildName, build.Status.Phase)
		}
		count++
	}

	// switch into project's cd openshift namespace - to find the build
	stdout, stderr, err := coreUtils.RunCommand(
		"oc",
		[]string{
			"project", jenkinsNamespace,
		}, []string{})

	// get the jenkins run build log
	stdout, stderr, err = RunScriptFromBaseDir(
		"tests/scripts/print-jenkins-log.sh",
		[]string{
			buildName,
		}, []string{})

	if err != nil {
		return "", fmt.Errorf("Could not execute tests/scripts/print-jenkins-log.sh\n - err:%s", err)
	}

	// still running, or we could not find it ...
	if count >= max {
		return "", fmt.Errorf(
			"Timeout during build: %s\nStdOut: %s\nStdErr: %s",
			buildName,
			stdout,
			stderr)
	} else {
		fmt.Printf(
			"buildlog: %s\n%s",
			buildName,
			stdout)
	}

	// get (executed) jenkins stages from run - the caller can compare against the golden record
	stdout, _, err = RunScriptFromBaseDir(
		"tests/scripts/print-jenkins-json-status.sh",
		[]string{
			buildName,
			jenkinsNamespace,
		}, []string{})

	if err != nil {
		return "", fmt.Errorf("Error getting jenkins stages for: %s\rError: %s", buildName, err)
	}

	return stdout, nil
}
