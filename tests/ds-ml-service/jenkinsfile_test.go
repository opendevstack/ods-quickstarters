package ds_ml_service

import (
	"fmt"
	"path/filepath"
	"runtime"
	"strings"
	"testing"

	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	utils "github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestDsMlService(t *testing.T) {

	config, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatal(err)
	}

	_, filename, _, _ := runtime.Caller(0)
	quickstarterPath := filepath.Dir(filename)
	quickstarterName := filepath.Base(quickstarterPath)
	const componentId = "ml"
	repoName := fmt.Sprintf("%s-%s", strings.ToLower(coreUtils.PROJECT_NAME), componentId)

	// cleanup and create bb resources for this test
	err = utils.CleanupAndCreateBitbucketProjectAndRepo(quickstarterName, componentId)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Run provision pipeline of %s ...\n", componentId)
	stages, err := utils.RunJenkinsFile(
		"ods-quickstarters",
		config["ODS_BITBUCKET_PROJECT"],
		config["ODS_GIT_REF"],
		coreUtils.PROJECT_NAME,
		fmt.Sprintf("%s/Jenkinsfile", quickstarterName),
		coreUtils.PROJECT_NAME_CD,
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
		coreUtils.EnvPair{
			Name:  "GIT_URL_HTTP",
			Value: fmt.Sprintf("%s/%s/%s.git", config["REPO_BASE"], coreUtils.PROJECT_NAME, repoName),
		},
		coreUtils.EnvPair{
			Name:  "ODS_NAMESPACE",
			Value: config["ODS_NAMESPACE"],
		},
	)
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("Provision pipeline run for %s returned:\n%s", componentId, stages)
	err = utils.VerifyJenkinsStages(componentId, "provisioning", "golden/jenkins-provision-stages.json", stages)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Run build pipeline of %s ...\n", componentId)
	stages, buildName, err := utils.RunJenkinsFileAndReturnBuildName(
		repoName,
		coreUtils.PROJECT_NAME,
		"master",
		coreUtils.PROJECT_NAME,
		"Jenkinsfile",
		coreUtils.PROJECT_NAME_CD,
		coreUtils.EnvPair{
			Name:  "COMPONENT_ID",
			Value: componentId,
		},
		coreUtils.EnvPair{
			Name:  "ODS_NAMESPACE",
			Value: config["ODS_NAMESPACE"],
		},
	)
	if err != nil {
		t.Fatal(err)
	}
	fmt.Printf("Build pipeline run for %s returned:\n%s", componentId, stages)
	err = utils.VerifyJenkinsStages(componentId, "build", "golden/jenkins-build-stages.json", stages)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Verify run attachments of %s ...\n", buildName)
	artifactsToVerify := []string{
		fmt.Sprintf("SCRR-%s.docx", repoName),
		fmt.Sprintf("SCRR-%s.md", repoName),
	}
	err = utils.VerifyJenkinsRunAttachments(coreUtils.PROJECT_NAME_CD, buildName, artifactsToVerify)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Verify unit tests of %s ...\n", buildName)
	stdout, _, err := utils.RunScriptFromBaseDir("tests/scripts/verify-jenkins-unittest-results.sh", []string{
		fmt.Sprintf("%s", buildName),
		fmt.Sprintf("%s", coreUtils.PROJECT_NAME_CD),
		fmt.Sprintf("%s", "2"), // number of tests expected
	}, []string{})

	if err != nil {
		t.Fatalf("Could not find unit tests for build:%s\n %s, err: %s\n",
			buildName, stdout, err)
	}

	fmt.Printf("Verify OpenShift resources of %s in %s ...\n", componentId, coreUtils.PROJECT_NAME_DEV)
	resources := coreUtils.Resources{
		Namespace: coreUtils.PROJECT_NAME_DEV,
		ImageTags: []coreUtils.ImageTag{{Name: componentId + "-training-service", Tag: "latest"},
			{Name: componentId + "-prediction-service", Tag: "latest"}},
		BuildConfigs:      []string{componentId + "-training-service", componentId + "-prediction-service"},
		DeploymentConfigs: []string{componentId + "-training-service", componentId + "-prediction-service"},
		Services:          []string{componentId + "-training-service", componentId + "-prediction-service"},
		ImageStreams:      []string{componentId + "-training-service", componentId + "-prediction-service"},
	}

	coreUtils.CheckResources(resources, t)

}
