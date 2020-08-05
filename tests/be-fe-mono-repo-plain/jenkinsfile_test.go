package be_fe_mono_repo_plain

import (
	"fmt"
	"path/filepath"
	"runtime"
	"strings"
	"testing"

	coreUtils "github.com/opendevstack/ods-core/tests/utils"
	utils "github.com/opendevstack/ods-quickstarters/tests/utils"
)

func TestBeFeMonoRepoPlain(t *testing.T) {

	config, err := utils.ReadConfiguration()
	if err != nil {
		t.Fatal(err)
	}

	_, filename, _, _ := runtime.Caller(0)
	quickstarterPath := filepath.Dir(filename)
	quickstarterName := filepath.Base(quickstarterPath)
	const componentId = "monorepo-iq-test"
	repoName := fmt.Sprintf("%s-%s", strings.ToLower(coreUtils.PROJECT_NAME), componentId)

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
	err = utils.VerifyJenkinsStages(componentId, "provisioning", "jenkins-provision-stages.json", stages)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Run build pipeline of %s ...\n", componentId)
	stages, err = utils.RunJenkinsFile(
		componentId,
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
	err = utils.VerifyJenkinsStages(componentId, "build", "jenkins-build-stages.json", stages)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("Verify OpenShift resources of %s in %s ...\n", componentId, coreUtils.PROJECT_NAME_DEV)
	resources := coreUtils.Resources{
		Namespace:         coreUtils.PROJECT_NAME_DEV,
		ImageTags:         []coreUtils.ImageTag{{Name: componentId + "-backend", Tag: "latest"}, {Name: componentId + "-frontend", Tag: "latest"}},
		BuildConfigs:      []string{componentId + "-backend", componentId + "-frontend"},
		DeploymentConfigs: []string{componentId},
		Services:          []string{componentId + "-backend", componentId + "-frontend"},
		ImageStreams:      []string{componentId + "-backend", componentId + "-frontend"},
	}

	coreUtils.CheckResources(resources, t)

}
