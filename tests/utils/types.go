package utils

type ImageTag struct {
	Name string
	Tag  string
}

type Resources struct {
	Namespace         string
	ImageTags         []ImageTag
	BuildConfigs      []string
	DeploymentConfigs []string
	Services          []string
	ImageStreams      []string
}

type CommitStatus struct {
	State string `json:"state"`
	Key   string `json:"key"`
	Name  string `json:"name"`
	URL   string `json:"url"`
}
