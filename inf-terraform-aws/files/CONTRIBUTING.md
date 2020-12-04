# Contributing

Thank you for your interest in this project!

You can make a contribution by:

1. Reporting bugs
2. Suggesting changes
3. Contributing source code (see below)

We use the [GitLab Issue Tracker](https://docs.gitlab.com/ee/user/project/issues/) for trackings bugs and change requests.

Before contributing a new feature, please discuss its suitability with the project maintainers in an issue first.

## Contribution Workflow

We enforce a so-called [Forking Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow). For more information, please refer to our more exhaustive documentation <sup>[1](#f1)</sup>.

1. Fork and clone

    1. Point your browser to the project’s official repository. Example: gitlab.eu.boehringer.com/CoE/blueprint-aws-vpc
    2. Fork the project into your personal namespace. Example: gitlab.eu.boehringer.com/waise/blueprint-aws-vpc
    3. Clone the project into your local workspace. Example:

``` bash
$> git clone git@gitlab.eu.boehringer.com:waise/blueprint-aws-vpc.git
Cloning into ‘blueprint-aws-vpc’...
```

2. Create a feature branch

```
$> git checkout -b add-feature-x
Switched to a new branch ‘add-feature-x’
```

```
$> git push origin add-feature-x
To git@gitlab.eu.boehringer.com:waise/blueprint-aws-vpc.git
 * [new branch]   add-feature-x -> add-feature-x
```

3. Develop code

4. File merge request

    1. Point your browser to the project’s personal repository. Example: gitlab.eu.boehringer.com/waise/blueprint-aws-vpc
    2. Create a *merge request* and follow the instructions in the merge request template.
    3. Perform a *code review* with the project maintainers who may suggest improvements or alternatives.
    4. Once approved, your code will be merged into `master` and you can safely purge your feature branch.

### Requirements

##### Small and focused commits

- Commits should be as small as possible and should come with a meaningful commit message.
- Commits should be focused and only introduce change where change is needed.

##### Code, tests, and documentation

Each commit should be self-contained in that any code change is accompanied by sufficient tests and up-to-date documentation.

## Additional Resources

- <a href="https://confluence.bi-scrum.com/display/ITINF/Development+Guidelines">Development Guidelines:</a> <a id="f1" href="https://confluence.bi-scrum.com/display/ITINF/Contribution">Contribution Guide</a> (Confluence)
