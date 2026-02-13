# Renovate

This is a quickstart template for Renovate, a tool for automating dependency updates in software projects.

## Features

- **Automated Dependency Updates**: Automatically keeps your dependencies up to date
- **Pull Request Integration**: Creates pull requests for each update, allowing for easy review and merging
- **Configurable**: Easily customize the behavior of Renovate to suit your project's needs
- **Support for Multiple Languages**: Works with a wide range of programming languages and package managers
- **Scheduling**: Configure when updates should be applied, such as daily, weekly, or monthly
- **Lock File Maintenance**: Ensures that lock files are kept in sync with the latest dependencies

Check out the [Renovate documentation](https://docs.renovatebot.com/) for more information on how to set up and configure Renovate for your project.

## Getting Started

1. Modify the `configmap.yaml` file to customize the Renovate configuration for your project
2. Supply the necessary credentials
   1. Configure your preferred way of specifying credentials (e.g. Helm Secrets or repository secrets with Transcrypt)
   2. (Recommended) For GitHub, create a personal access token to fetch changelogs of dependencies
   3. (Optional) For Nexus, create a token to access special packages

## Recommended Configuration Options

If `onboarding` is set to `true` in the config, Renovate will automatically create a pull request to add a `renovate.json` file to your repository. This file will contain the default configuration for Renovate.
Decide whether you want Renovate to scan all repositories it has access to or just specific ones.

```js
// configmap.yaml
module.exports = {
  // ... other configuration options
  "repositories": ["PROJECTID/COMPONENTID"]
}
```

If you need Renovate to speak to a custom Nexus host, add the `NEXUS_HOST` environment variable to your configuration. Also, set the environment variable `NEXUS_TOKEN` similar to the GITHUB_TOKEN.

```js
// configmap.yaml
module.exports = {
  // ... other configuration options
  "hostRules": [
    // ... other host rules
    {
      "matchHost": "nexus.digitale-hub.com",
      "token": process.env.NEXUS_TOKEN
    }
  ]
}
```

## Further Resources

### Documentation

#### Renovate specific

- [Renovate Documentation](https://docs.renovatebot.com)
- [Renovate Configuration Options](https://docs.renovatebot.com/configuration-options)
- [Renovate Presets](https://docs.renovatebot.com/config-presets)

#### Secrets Management

- [Helm Secrets Plugin](https://github.com/jkroepke/helm-secrets)
- [Transcrypt](https://github.com/elasticdog/transcrypt)
