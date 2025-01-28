# Changelog

## Unreleased

### Added

### Changed

### Fixed

## [4.7.0] - 2025-1-27

### Added
- Introduce Rust Quickstarter dependency graph linting (cargo-deny) and upgrade maintenance ([#1061](https://github.com/opendevstack/ods-quickstarters/issues/1061))
- Enable OpenSSL vendored compilation for Rust Jenkins Agent ([#1026](https://github.com/opendevstack/ods-quickstarters/pull/1026))
- Added custom reporter to Cypress Quickstarter and update dependencies ([#1034](https://github.com/opendevstack/ods-quickstarters/pull/1034))
- Add microsoft-edge to nodejs agents for using with cypress ([#1063](https://github.com/opendevstack/ods-quickstarters/pull/1063))
- Added new function to cypress to log into applications using MFA ([#1070](https://github.com/opendevstack/ods-quickstarters/pull/1070))

### Changed
- Removal of deprecated versions ([#1068](https://github.com/opendevstack/ods-quickstarters/issues/1068))
- Update OS packages by default and bump gitleaks version ([#1049](https://github.com/opendevstack/ods-quickstarters/issues/1049))
- Install java 17 devel only in scala and jdk agents ([#1057](https://github.com/opendevstack/ods-quickstarters/pull/1057))
- Update Angular, Ionic and Typescript Quickstarters ([#1033](https://github.com/opendevstack/ods-quickstarters/issues/1033))
- Update Rust Axum Quickstarter to Rust 1.79.0 ([#1024](https://github.com/opendevstack/ods-quickstarters/pull/1024))
- Update Rust Axum Quickstarter to Rust 1.80.1 and improve Agent build configuration ([#1040](https://github.com/opendevstack/ods-quickstarters/pull/1040))
- Rust Jenkins agent and Quickstarter updates of January 2025 ([#1087](https://github.com/opendevstack/ods-quickstarters/issues/1087))
- Mobile testing enablement adding Appium & Sauce Labs in e2e-spock-geb quickstarter ([#1083](https://github.com/opendevstack/ods-quickstarters/pull/1083))
- Generate PDF report for cypress and improved environment management ([#1079](https://github.com/opendevstack/ods-quickstarters/pull/1079))
- Change PDF report zip file name in Cypress Quickstarter ([#1082](https://github.com/opendevstack/ods-quickstarters/pull/1082))
- Improvements in the reporter for cypress ([#1042](https://github.com/opendevstack/ods-quickstarters/issues/1042))
- Support for Python3.12, and maintenance of be-python-flask quickstarter and python Jenkins agent ([#1030](https://github.com/opendevstack/ods-quickstarters/pull/1030))
- Update Streamlit Quickstarter ([#1030](https://github.com/opendevstack/ods-quickstarters/issues/1030))
- Update Golang agent ([#1031](https://github.com/opendevstack/ods-quickstarters/issues/1031))
- Update gateway/nginx Quickstarter ([#1048](https://github.com/opendevstack/ods-quickstarters/pull/1048))
- Gitleaks docs fix and update ([#1028](https://github.com/opendevstack/ods-quickstarters/issues/1028))
- Update jdk and scala quickstarters and agents ([#1032](https://github.com/opendevstack/ods-quickstarters/issues/1032))

### Fixed
- inf-terraform-aws: Fix .devcontainer directory and its configuration template missing in latest AWS Quickstarter ([#1091](https://github.com/opendevstack/ods-quickstarters/pull/1091))
- Replaced centos8 repository for AlmaLinux 8 due to deprecation ([#1063](https://github.com/opendevstack/ods-quickstarters/pull/1063))
- Nodejs agents should make use of the installed certificates in the agent ([#1078](https://github.com/opendevstack/ods-quickstarters/issues/1078))
- Fix for npm based jenkins agents to support private nexus repositories ([#1059](https://github.com/opendevstack/ods-quickstarters/issues/1059))
- Fix Ruby installation with high amount of CPU cores ([#1084](https://github.com/opendevstack/ods-quickstarters/issues/1084))
- Included small fixes in e2e-cypress ([#1086](https://github.com/opendevstack/ods-quickstarters/pull/1086))
- Fix ETL Python QS: AWS Test codepipeline Status Managment and update cryptography dependency([#1056](https://github.com/opendevstack/ods-quickstarters/pull/1052))
- Fix permissions in Golang agent for the golden tests ([#1052](https://github.com/opendevstack/ods-quickstarters/pull/1052))

## [4.6.0] - 2024-10-23

### Changed
- inf-terraform-[aws|azure]: bump terraform versions, pre-commit-hooks, library versions ([#1036](https://github.com/opendevstack/ods-quickstarters/pull/1036))
- jenkins-agent-terraform-2408: add jenkins agent terraform-2408, add go-task, go for experimental terratest, add python-3.12 (drop python-3.8), use tenv for terraform (tofu) version management, ruby version 3.3.4, terraform 1.9.4 ([#1036](https://github.com/opendevstack/ods-quickstarters/pull/1036))

### Fixed
- Replaced centos8 repository for RockyLinux 8 due to deprecation in terraform agents ([#1036](https://github.com/opendevstack/ods-quickstarters/pull/1036))
- Remove obsolete branch parameter from release-manager ([#1058](https://github.com/opendevstack/ods-quickstarters/pull/1058))

## [4.5.0] - 2024-06-06

### Added
- Added nodejs22 agent and switch install of node to nodesource ([#1011](https://github.com/opendevstack/ods-quickstarters/pull/1011))

### Changed
- Update Ionic Quickstarter ([#1009](https://github.com/opendevstack/ods-quickstarters/pull/1009))
- Update Angular Quickstarter ([#1019](https://github.com/opendevstack/ods-quickstarters/pull/1019))

### Fixed
- Workaround for centos 8 stream repository deprecation ([#1021](https://github.com/opendevstack/ods-quickstarters/issues/1021))

## [4.4.0] - 2024-04-22

### Added
- Added secret scanning (gitleaks) in all quickstarters ([#963](https://github.com/opendevstack/ods-quickstarters/pull/963))

### Changed
- Update api version in ocp templates for image, buildconfig, route and deploymentconfig ([#1072](https://github.com/opendevstack/ods-jenkins-shared-library/issues/1072))
- Update Makefile adding all missing agents ([#999](https://github.com/opendevstack/ods-quickstarters/pull/999))

### Fixed
- jenkins agent nodejs20 can not import private keys into gpg keyring to use with helm secrets ([#1001](https://github.com/opendevstack/ods-quickstarters/issues/1001))

## [4.3.1] - 2024-02-19

### Added
- Rust Quickstarter with Axum web framework simple boilerplate ([#980](https://github.com/opendevstack/ods-quickstarters/issues/980))
- Added ETL pipeline testing QS (e2e-python) ([#985](https://github.com/opendevstack/ods-quickstarters/pull/985))
- Added Nodejs20 agent ([#962](https://github.com/opendevstack/ods-quickstarters/issues/962))
- Added java 21 to jdk agent, updated Springboot and Spock quickstarters ([#962](https://github.com/opendevstack/ods-quickstarters/issues/962))

### Modified
- Update Streamlit and Python quickstarters and agent ([#968](https://github.com/opendevstack/ods-quickstarters/issues/968)) & ([#982](https://github.com/opendevstack/ods-quickstarters/pull/982))
- Update gateway-Nginx quickstarter ([#983](https://github.com/opendevstack/ods-quickstarters/pull/983))
- Remove nodejs12 form the code ([#936](https://github.com/opendevstack/ods-quickstarters/issues/936))
- Update release manager readme ([#969](https://github.com/opendevstack/ods-quickstarters/issues/969))
- Maintenance for Golang Agent and QuickStarter ([#955](https://github.com/opendevstack/ods-quickstarters/issues/955))
- Update Angular, TypeScript, Cypress and Ionic quickstarters ([#962](https://github.com/opendevstack/ods-quickstarters/issues/962))

### Fixed
- jenkins agents can not import private keys into gpg keyring to use with helm secrets ([#945](https://github.com/opendevstack/ods-quickstarters/issues/945))
- Streamlit quickstarter build fails to import nexus host certificates into truststore ([#951](https://github.com/opendevstack/ods-quickstarters/issues/951))
- Rust Quickstarter Jenkins Agent CICD tools with fixed versions ([#988](https://github.com/opendevstack/ods-quickstarters/issues/988))

## [4.3.0] - 2023-07-13

### Added
- Addition of streamlit quickstarter ([#891](https://github.com/opendevstack/ods-quickstarters/issues/891))
- Cypress Cloud integration and switch to nodejs 18 ([#935](https://github.com/opendevstack/ods-quickstarters/pull/935))
- Provide build agent for Node.js 18 ([#794](https://github.com/opendevstack/ods-quickstarters/issues/794))

### Modified
- Generate one xml report per spec and merge them later ([#898](https://github.com/opendevstack/ods-quickstarters/pull/898))
- Removal of Centos agents ([#1209](https://github.com/opendevstack/ods-core/issues/1209))
- Update of Python agent, Python, Streamlit and Jupyter quickstarters ([#902](https://github.com/opendevstack/ods-quickstarters/issues/902))
- inf-terraform-aws: remove cloudformation stack from default quickstarter ([#934](https://github.com/opendevstack/ods-quickstarters/pull/934))
- inf-terraform-aws: switch from shared statefile location to dedicated ([#932](https://github.com/opendevstack/ods-quickstarters/pull/932))
- Change sonar-scan.json and release manager template to use any project ([#933](https://github.com/opendevstack/ods-quickstarters/pull/933))
- Add binutils package to jdk-17 agent ([#929](https://github.com/opendevstack/ods-core/issues/929))
- inf-terraform-[aws|azure], bump inspec-aws (v1.83.60) & inspec-azure (v1.118.41) library versions, drop use of symbolized keys in helper yaml files ([#927](https://github.com/opendevstack/ods-quickstarters/pull/927))
- inf-terraform-[aws|azure], jenkins-agent-terraform-2306 with tooling update (ruby 3.2.2, python 3.11) ([#923](https://github.com/opendevstack/ods-quickstarters/pull/923))
- Update python agent, pyhon, streamlit and jupyter quickstarters to 3.11 ([#924](https://github.com/opendevstack/ods-quickstarters/pull/924))
- Upgrade to Cypress 12 ([#908](https://github.com/opendevstack/ods-quickstarters/pull/908))
- Update scala agent and be-scala-play quickstarter ([#919](https://github.com/opendevstack/ods-quickstarters/pull/919))
- Update Ionic Quickstarter ([#917](https://github.com/opendevstack/ods-quickstarters/pull/917))
- Update Go quickstarter to Go 1.20 and align version of golangci-lint and go-junit-report ([#915](https://github.com/opendevstack/ods-quickstarters/pull/915))
- Rename maven-agent to jdk-agent, update springboot & spock-geb quickstarters ([#901](https://github.com/opendevstack/ods-quickstarters/pull/901))
- Update Angular and TypeScript quickstarters ([#910](https://github.com/opendevstack/ods-quickstarters/pull/910))
- Upgrade be-gateway-nginx to rocky 1.21 openresty/nginx ([#883](https://github.com/opendevstack/ods-quickstarters/pull/883))
- Set default rollout strategy to recreate ([#926](https://github.com/opendevstack/ods-quickstarters/issues/926))

### Fixed
- Fix oauth-proxy sidecar image ([#862](https://github.com/opendevstack/ods-quickstarters/issues/862))
- Fix Jenkinsfile params in StreamLit ([#941](https://github.com/opendevstack/ods-quickstarters/pull/941)) ([#939](https://github.com/opendevstack/ods-quickstarters/pull/939))
- Fixed Angular build for error "Unknown argument: sourceMap" ([#940](https://github.com/opendevstack/ods-quickstarters/pull/940))
- Fix mismatch on java version in base and jdk agents ([#916](https://github.com/opendevstack/ods-quickstarters/pull/916))
- TypeScript QS fails to build ([#897](https://github.com/opendevstack/ods-quickstarters/issues/897))
- Issues with agent permision in new OCP version ([#901](https://github.com/opendevstack/ods-quickstarters/pull/901))
- Removed protractor-related configuration from `ini.sh` in Ionic quickstarter ([#885](https://github.com/opendevstack/ods-quickstarters/issues/885))
- change /tmp permissions in inf-terraform-agent ([#903](https://github.com/opendevstack/ods-quickstarters/pull/903))
- nodejs 18 agent builds fail ([#905](https://github.com/opendevstack/ods-quickstarters/issues/905))
- Fix imagePullPolicy issue when verifying the image ([#874](https://github.com/opendevstack/ods-quickstarters/issues/874))
- Fix Release manager Jenkinsfile ([#943](https://github.com/opendevstack/ods-quickstarters/pull/943))

## [4.1] - 2022-11-17

### Added

- ODS AMI build fails due to failing jacoco report generation in springboot quickstarter ([#700](https://github.com/opendevstack/ods-quickstarters/pull/700))
- Add Node.js 16 builder agent ([#763](https://github.com/opendevstack/ods-quickstarters/issues/763))
- Add Azure Quickstarter ([#788](https://github.com/opendevstack/ods-quickstarters/issues/788))
- Add Node.js 18 builder agent ([#763](https://github.com/opendevstack/ods-quickstarters/issues/794))

### Modified

- Add JVM parameters on docgen deployment 4x ([#671](https://github.com/opendevstack/ods-quickstarters/pull/671))
- Updates maven agent to support HTTPS proxy ([#689](https://github.com/opendevstack/ods-quickstarters/issues/689))
- Enforces use of secure Log4j version in SpringBoot Quickstarter ([#693](https://github.com/opendevstack/ods-quickstarters/issues/693))
- Use Java 17 (LTS) in maven jenkins-agent and spring boot qs ([#651](https://github.com/opendevstack/ods-quickstarters/pull/651))
- Jupyter Lab: reduction to a minimal initial env ([#710](https://github.com/opendevstack/ods-quickstarters/issues/710))
- terraform agent sops/age added ([#730](https://github.com/opendevstack/ods-quickstarters/issues/730))
- Upgrade python flask quickstarter to Flask 2 version and general dependencies upgrades ([#746](https://github.com/opendevstack/ods-quickstarters/issues/746))
- inf-terraform-aws: Update versions for ruby, terraform, kitchen-terraform, Gemfile ([#677](https://github.com/opendevstack/ods-quickstarters/issues/677))
- terraform agent updated from Jenkins base image changes ([#724](https://github.com/opendevstack/ods-quickstarters/issues/724))
- inf-terraform-aws: is using the new odsComponentStageInfrastructure concept now ([#631](https://github.com/opendevstack/ods-quickstarters/issues/631))
- inf-terraform-aws: enable devcontainer support ([#736](https://github.com/opendevstack/ods-quickstarters/issues/736))
- Add Node.js 16 builder agent ([#763](https://github.com/opendevstack/ods-quickstarters/issues/763)
- Update fe-angular to Angular 13.3.0 ([#765](https://github.com/opendevstack/ods-quickstarters/issues/765))
- Switch fe-angular, fe-ionic and be-typescript-express to Node.js 16 builder agent ([#763](https://github.com/opendevstack/ods-quickstarters/issues/763)
- Update and improve e2e-cypress quickstarter ([#770](https://github.com/opendevstack/ods-quickstarters/issues/770))
- Update fe-ionic to Ionic 6.19.0 ([#780](https://github.com/opendevstack/ods-quickstarters/issues/780))
- Upgrade atlassian stack (Implements [#1138](https://github.com/opendevstack/ods-core/issues/1138))
- inf-terraform-agent: add Python 3.9.x back and add Python 3.8 in addition to ubi8 ([#822](https://github.com/opendevstack/ods-quickstarters/issues/822))
- Updated spring boot version to 2.7.1 ([#779](https://github.com/opendevstack/ods-quickstarters/issues/779))
- Add packages for python agent ([#809](https://github.com/opendevstack/ods-quickstarters/issues/809))
- Added azure-cli to terraform agent ([#628](https://github.com/opendevstack/ods-quickstarters/issues/628))
- Add JVM parameters on docgen deployment ([#669](https://github.com/opendevstack/ods-quickstarters/pull/669))
- Add missing directory ([#679](https://github.com/opendevstack/ods-quickstarters/issues/679))
- Rewrote the Cloud Formation Stack Example ([#683](https://github.com/opendevstack/ods-quickstarters/issues/683))
- Enforce use of secure Log4j version in SpringBoot Quickstarter ([#693](https://github.com/opendevstack/ods-quickstarters/issues/693))
- jupyter lab: reduction to a minimal initial env ([#710](https://github.com/opendevstack/ods-quickstarters/issues/710))
- inf-terraform-agent: consistent use of Python 3.9.x ([#793](https://github.com/opendevstack/ods-quickstarters/pull/793))
- e2e-cypress: use Node.js 16 for deployment ([#853](https://github.com/opendevstack/ods-quickstarters/issues/853))
- inf-terraform-aws: update AWS QS and agent libraries, Terraform version  ([#849](https://github.com/opendevstack/ods-quickstarters/pull/849))
- inf-terraform-aws: add feature clean & check-config  ([#784](https://github.com/opendevstack/ods-quickstarters/issues/784))
- inf-terraform-azure: update Azure QS and agent libraries, Terraform version  ([#856](https://github.com/opendevstack/ods-quickstarters/pull/856))
- be-python-flask, ds-jupyter-lab: upgrade to python3.9, and keep support of python3.8([#865](https://github.com/opendevstack/ods-quickstarters/issues/865))
- Remove support for the url repository field in metadata.yml ([#868](https://github.com/opendevstack/ods-quickstarters/pull/868))

### Fixed

- Quickstarters should specify the resources for the rollout process ([#797](https://github.com/opendevstack/ods-quickstarters/issues/797))
- inf-terraform-agent: fix pip update and epel installation
- Mavent agent updated from Jenkins base image changes ([#722](https://github.com/opendevstack/ods-quickstarters/issues/722))
- NodeJS12 agent updated from Jenkins base image changes ([#720](https://github.com/opendevstack/ods-quickstarters/issues/720))
- Scala agent updated from Jenkins base image changes ([#721](https://github.com/opendevstack/ods-quickstarters/issues/721))
- terraform agent updated from Jenkins base image changes ([#724](https://github.com/opendevstack/ods-quickstarters/issues/724))
- Default acceptance test in Spock makes the pipeline runs forever ([#706](https://github.com/opendevstack/ods-quickstarters/issues/706))
- Drop prerelease of antora page version in 4.x ([#66](https://github.com/opendevstack/ods-documentation/issues/66))
- Python Jenkinsfile use python3.8 ([#682](https://github.com/opendevstack/ods-quickstarters/issues/682))
- ODS AMI build failing due an E2E test error of ionic quickstarter ([#742](https://github.com/opendevstack/ods-quickstarters/issues/742))
- ODS AMI build failing due an missing list of supported browsers in ionic quickstarter ([#756](https://github.com/opendevstack/ods-quickstarters/issues/756))
- inf-terraform-aws: Fix error handling of Makefile ([#680](https://github.com/opendevstack/ods-quickstarters/issues/680))
- Remove jcenter repositories from quickstarters (Fixes [#804](https://github.com/opendevstack/ods-quickstarters/issues/804))
- Fix non-working jdk-17 usage (Fixes [#808](https://github.com/opendevstack/ods-quickstarters/issues/808))
- Full revision of Jenkins Pipelines, to make them work again. Increased timeouts for building quickstarters and added the retrieval of the return status for building each quickstarter.
- Stage name not updated in latest version ([#816](https://github.com/opendevstack/ods-quickstarters/issues/816))
- fix azure jenkinsfile.template ([#832](https://github.com/opendevstack/ods-quickstarters/pull/832))
- Fixed e2e-spock-geb quickstarter groovy tests runs twice ([#874](https://github.com/opendevstack/ods-jenkins-shared-library/issues/874))
- inf-terraform-azure: fix configuration of testing
- Groovy junit tests cannot be run twice (Fixes [#814](https://github.com/opendevstack/ods-quickstarters/issues/814))
- Nodejs12 agent docker image sometimes fails to reach pkgs it needs to download for installation. (Fixes [#819](https://github.com/opendevstack/ods-quickstarters/issues/819))
- Fixes docgen pod assigned memory issue ([#837](https://github.com/opendevstack/ods-quickstarters/pull/837))
- Update nodejs version in TypeScript Quickstarter ([#834](https://github.com/opendevstack/ods-quickstarters/issues/834))
- Fix nodejs12 build fails with redhat jenkins agent ([#843](https://github.com/opendevstack/ods-quickstarters/issues/843))
- Fix Build Terraform UBI agent fails ([#847](https://github.com/opendevstack/ods-quickstarters/issues/847))
- Fix failing acceptance test in cypress quickstarter ([#840](https://github.com/opendevstack/ods-quickstarters/issues/840))

## [4.0] - 2021-11-05

### Added

- ds-rshiny cleanup cloudera dependency ([#540](https://github.com/opendevstack/ods-quickstarters/pull/540))
- Add SaaS documentation quickstarter ([#556](https://github.com/opendevstack/ods-quickstarters/pull/556))
- Documented the metadata file and its relationship with the labeling functionality ([#638](https://github.com/opendevstack/ods-quickstarters/pull/638))
- requests access logging enabled for openshift oauth proxy component (used by ds-rshiny and ds-jupyter-lab) ([#590](https://github.com/opendevstack/ods-quickstarters/issues/590))
- e2e-cypress: Added support for login with Azure SSO + MSALv2 ([#601](https://github.com/opendevstack/ods-quickstarters/pull/601))
- terraform jenkins agent: Added AWS SAM CLI and AWS CDK ([#608](https://github.com/opendevstack/ods-quickstarters/pull/608))
- Add Azure Quickstarter ([#788](https://github.com/opendevstack/ods-quickstarters/issues/788))

### Changed

- ds-rshiny upgrade and housekeeping ([#563](https://github.com/opendevstack/ods-quickstarters/issues/563))
- ds-jupyter-notebook renamed to ds-jupyter-lab, upgrade to JupyterLab 3 and UBI8 base image introduction ([#562](https://github.com/opendevstack/ods-quickstarters/issues/562))
- be-python-flask housekeeping and UBI8 base image introduction ([#585](https://github.com/opendevstack/ods-quickstarters/issues/585))
- be-gateway-nginx upgrade (OpenResty/nginx 1.19.3) and maintenance ([#588](https://github.com/opendevstack/ods-quickstarters/issues/588))
- e2e-cypress: Updated Cypress + dependencies to latest compatible versions ([#601](https://github.com/opendevstack/ods-quickstarters/pull/601)), ([#603](https://github.com/opendevstack/ods-quickstarters/issues/603))
- inf-terraform-aws: Update terraform version from 0.14.11 to 1.0.3, update kitchen-terraform to 5.8.0, remove Pipfile.lock, bump hashcorp/random to 3.1.0, rename inspec test suite from stackdefault to stack, bump inspec-aws to 1.51.5, bump inspec to 4.37.30, bump ruby to 2.7.4, add cfn-lint to pre-commit-hooks, set QS version to 4.1 in metadata, drop TF_WARN_OUTPUT_ERRORS=1 when running kitchen verify ([#617](https://github.com/opendevstack/ods-quickstarters/pull/617))

### Modified

- Added correct ionic package in Jenkinsfile ([#580](https://github.com/opendevstack/ods-quickstarters/pull/581))
- Removed forcing eslint configuration as it is default ([#573](https://github.com/opendevstack/ods-quickstarters/pull/578))
- Default linter for Ionic is now eslint as tslint is deprecated ([#573](https://github.com/opendevstack/ods-quickstarters/pull/575))
- Upgraded Ionic CLI to v6.13.1 ([#577](https://github.com/opendevstack/ods-quickstarters/pull/577))
- Updating used base image for nginx to fix CVE ([#602](https://github.com/opendevstack/ods-quickstarters/pull/602))
- be-gateway-nginx switch from CentOS to Fedora ([#611](https://github.com/opendevstack/ods-quickstarters/issues/611))
- Change rhel7 to centos7 base jenkins node, as the image is Centos (congruent with ods-core) ([#646](https://github.com/opendevstack/ods-quickstarters/pull/646))
- Update external url dependencies ([#649](https://github.com/opendevstack/ods-quickstarters/pull/649))

### Fixed

- jenkins nodejs12 agent build failing due to incompatible chrome package with centos 7 ([#656](https://github.com/opendevstack/ods-quickstarters/pull/656))
- ds-rshiny cleanup cloudera dependency ([#540](https://github.com/opendevstack/ods-quickstarters/pull/540))
- Removed forcing eslint configuration as it is default ([#573](https://github.com/opendevstack/ods-quickstarters/pull/578))
- Recover be-python-flask ([#583](https://github.com/opendevstack/ods-quickstarters/issues/583))
- ds-rshiny quickstarter goes to broken repository ([#605](https://github.com/opendevstack/ods-quickstarters/issues/605))
- Fix UBI8 Build for Terraform Agent
- ds-rshiny not able to deploy in OCP 4 ([#609](https://github.com/opendevstack/ods-quickstarters/issues/609))
- fixed mixed line endings on multiple files ([#618](https://github.com/opendevstack/ods-quickstarters/issues/618))
- fix dead sbt rpm bintray repo ([#622](https://github.com/opendevstack/ods-quickstarters/issues/622))
- openjdk 11 does not recognize VM setting ([#623](https://github.com/opendevstack/ods-quickstarters/issues/623))
- inf-terraform-aws - drop Pipfile.lock
- fix r-shiny build behind proxy ([#627](https://github.com/opendevstack/ods-quickstarters/issues/627))
- fix environment templates (AWS QS) ([#629](https://github.com/opendevstack/ods-quickstarters/issues/629))
- fix Smoke Test Region (AWS QS) ([#633](https://github.com/opendevstack/ods-quickstarters/issues/633)
- fix openshift templates deprecation notice ([#639](https://github.com/opendevstack/ods-quickstarters/issues/639))
- Bumps jupyterlab from 3.0.14 to 3.0.17 by @dependabot security finding ([#641](https://github.com/opendevstack/ods-quickstarters/pull/641))
- fix nodejs 12 jenkins agent build failing ([#642](https://github.com/opendevstack/ods-quickstarters/issues/642)
- fix typescript-express junit test location ([#654](https://github.com/opendevstack/ods-quickstarters/issues/654))
- fix java not in path for python quickstarter ([#685](https://github.com/opendevstack/ods-quickstarters/issues/685))
- fix gitignore in inf-terraform ([#767](https://github.com/opendevstack/ods-quickstarters/issues/767))
- fix e2e-spock-geb quickstarter groovy tests runs twice ([#874] https://github.com/opendevstack/ods-jenkins-shared-library/issues/874)

### Removed

- ds-ml-service deprecated and moved to extra-quickstarters ([#568](https://github.com/opendevstack/ods-quickstarters/issues/568))

## [3.0] - 2020-08-11

### Added
- Feature/add complex RM test features, and use doc downloading tests ([#404](https://github.com/opendevstack/ods-quickstarters/pull/404))
- Quickstarters need to generate code coverage (and report to SQ) ([#213](https://github.com/opendevstack/ods-quickstarters/issues/213))
- set nexus as default pip repo index for jenkins python agent ([#396](https://github.com/opendevstack/ods-quickstarters/issues/396))
- extend quickstarter tests - to reflect a real installation qualification ([#347](https://github.com/opendevstack/ods-quickstarters/issues/347))
- Use new image import strategy if possible ([#358](https://github.com/opendevstack/ods-quickstarters/pull/358))
- Allow target branch configuration for a created quickstarter ([#271](https://github.com/opendevstack/ods-quickstarters/issues/271))
- Add ods namespace to release manager quickstarter ([#283](https://github.com/opendevstack/ods-quickstarters/pull/283))
- Add gcc/g++ to support builds with CGO_ENABLED=1 ([#230](https://github.com/opendevstack/ods-quickstarters/issues/230))
- Allow configuration of BB project ([#276](https://github.com/opendevstack/ods-quickstarters/pull/276))
- Quickstarter creation guide ([#239](https://github.com/opendevstack/ods-quickstarters/issues/239))
- Custom agent image creation guide ([#264](https://github.com/opendevstack/ods-quickstarters/issues/264))
- Add be-gateway quickstarter ([#56](https://github.com/opendevstack/ods-quickstarters/issues/56))
- Make ds-ml-quickstarter work with mono-repo MRO implementation ([#231](https://github.com/opendevstack/ods-quickstarters/issues/231))
- Add Makefile ([#221](https://github.com/opendevstack/ods-quickstarters/pull/221))
- Add e2e-spock-geb quickstarter ([#91](https://github.com/opendevstack/ods-quickstarters/pull/91))
- Provide quickstarter metadata in release-manager.yml ([#75](https://github.com/opendevstack/ods-quickstarters/issues/75))
- Add release-manager quickstarter documentation ([#98](https://github.com/opendevstack/ods-quickstarters/pull/98))
- Add AWS quickstarter ([#515](https://github.com/opendevstack/ods-quickstarters/pull/515))
- Add AWS Terraform agent into makefile ([#570](https://github.com/opendevstack/ods-quickstarters/pull/570))

### Changed
- Upgrade to the latest python 3.8 ([#415](https://github.com/opendevstack/ods-quickstarters/issues/415))
- get build name dynamically from webhook proxy response ([#364](https://github.com/opendevstack/ods-quickstarters/pull/364))
- airflow-cluster moved to extra-quickstarters ([#351](https://github.com/opendevstack/ods-quickstarters/pull/351))
- Make config resources clear in prov-app quickstarter Jenkinsfile ([#349](https://github.com/opendevstack/ods-quickstarters/issues/349))
- fail R-Shiny build if app.R dependencies are not found/installed ([#331](https://github.com/opendevstack/ods-quickstarters/issues/331))
- Angular / Node Builds are not distinguishing between DEV and PROD Environment ([#18](https://github.com/opendevstack/ods-quickstarters/issues/18))
- Fix Jenkins slaves build config (add resource constraints) ([#297](https://github.com/opendevstack/ods-quickstarters/pull/297))
- Use resourceName config option ([#286](https://github.com/opendevstack/ods-quickstarters/pull/286))
- MRO integration - metadata yml for quickstarter should define component's type, not release manager's metadata ([#247](https://github.com/opendevstack/ods-quickstarters/issues/247))
- Set default branch to master instead of production ([#279](https://github.com/opendevstack/ods-quickstarters/pull/279))
- Read namespace of central images from context ([#272](https://github.com/opendevstack/ods-quickstarters/issues/272))
- update archiveName property in gradle.build ([#104](https://github.com/opendevstack/ods-quickstarters/issues/104))
- Adapt release manager quickstarter to merged MRO ([#256](https://github.com/opendevstack/ods-quickstarters/issues/256))
- Tests should not point to custom branch ([#228](https://github.com/opendevstack/ods-quickstarters/issues/228))
- Use Go mod init ([#86](https://github.com/opendevstack/ods-quickstarters/issues/86))
- Get rid of boilerplate in Jenkinsfile ([#244](https://github.com/opendevstack/ods-quickstarters/issues/244))
- Update Go to 1.14 ([#248](https://github.com/opendevstack/ods-quickstarters/issues/248))
- Update Jenkinsfile templates to use new stages ([#224](https://github.com/opendevstack/ods-quickstarters/pull/224))
- MRO / Quality Release tracking issues for quickstarters ([#175](https://github.com/opendevstack/ods-quickstarters/issues/175))
- Provisioning a release manager should not redeploy Jenkins ([#206](https://github.com/opendevstack/ods-quickstarters/issues/206))
- unify stage names and also use @ for library imports ([#160](https://github.com/opendevstack/ods-quickstarters/pull/160))
- enable WSGI for python related quickstarters ([#82](https://github.com/opendevstack/ods-quickstarters/issues/82))
- Update and improve docker-plain quickstarter docs ([#102](https://github.com/opendevstack/ods-quickstarters/pull/102))
- Bump urllib by bot ([#566](https://github.com/opendevstack/ods-quickstarters/issues/566))

### Fixed
- fix issue with too long names on be-typescript-express ([#378](https://github.com/opendevstack/ods-quickstarters/pull/378))
- Latest jenkins-slave-base:v3.11 breaks jenkins-agent-maven ([#354](https://github.com/opendevstack/ods-quickstarters/issues/354))
- fix ds components templates ([#344](https://github.com/opendevstack/ods-quickstarters/pull/344))
- ds-ml-service fails with new python jenkins agent at lint stage ([#333](https://github.com/opendevstack/ods-quickstarters/issues/333))
- ds component yaml service and deploymentconfig selectors do not match ([#337](https://github.com/opendevstack/ods-quickstarters/issues/337))
- Scala play quickstarter broken ([#323](https://github.com/opendevstack/ods-quickstarters/issues/323))
- R-Shiny quickstarter app.R uses deprecated package ([#329](https://github.com/opendevstack/ods-quickstarters/issues/329))
- TypeScript quickstarter defines no TypeScript version ([#95](https://github.com/opendevstack/ods-quickstarters/issues/95))
- duplication of prod flag in fe-angular ([#324](https://github.com/opendevstack/ods-quickstarters/pull/324))
- e2e cypress not compatible with mro for e2e testing ([#165](https://github.com/opendevstack/ods-quickstarters/issues/165))
- NodeJS 10 slave image fails to build ([#295](https://github.com/opendevstack/ods-quickstarters/issues/295))
- Update Typescript Version in 'be-typescript-express' & 'fe-ionic' due to sonarqube failing ([#88](https://github.com/opendevstack/ods-quickstarters/issues/88))
- Build fails for yarn install on nodejs slave ([#275](https://github.com/opendevstack/ods-quickstarters/issues/275))
- Components log wrong ODS shared library version ([#148](https://github.com/opendevstack/ods-quickstarters/issues/148))
- be-java-springboot generates incompatible JaCoCo configuration ([#225](https://github.com/opendevstack/ods-quickstarters/issues/225))
- Spring Boot should create Java 11 project by default ([#103](https://github.com/opendevstack/ods-quickstarters/issues/103))
- Jupyter Notebook quickstarter defines no Jupyter version ([#96](https://github.com/opendevstack/ods-quickstarters/issues/96))
- Quickstarters have inconsistent stage naming for build / test stage ([#159](https://github.com/opendevstack/ods-quickstarters/issues/159))
- Python Flask quickstarter has no Flask version ([#94](https://github.com/opendevstack/ods-quickstarters/issues/94))
- be-python-flask CoverageException("No data to report.") ([#55](https://github.com/opendevstack/ods-quickstarters/issues/55))
- Fix AMI pipeline ([#393](https://github.com/opendevstack/ods-quickstarters/pull/393))
- python agent should build lib packages for python packages that need compiling ([#407](https://github.com/opendevstack/ods-quickstarters/issues/407))
- MRO / monorepo quickstarter fixes ([#233](https://github.com/opendevstack/ods-quickstarters/pull/233))

### Removed
- Remove deprecated dockerImageRepository field ([#369](https://github.com/opendevstack/ods-quickstarters/pull/369))
- Remove --watch option from npm run build command ([#341](https://github.com/opendevstack/ods-quickstarters/issues/341))
- Remove deprecated sonar.language property ([#325](https://github.com/opendevstack/ods-quickstarters/pull/325))
- Remove old Scala quickstarter ([#138](https://github.com/opendevstack/ods-quickstarters/issues/138))
- Remove outdated be-scala-akka, fe-vue and fe-react quickstarters ([#322](https://github.com/opendevstack/ods-quickstarters/pull/322))

## [2.0] - 2019-12-13

### Added
- Quickstarter-specific memory quotas ([#12](https://github.com/opendevstack/ods-quickstarters/issues/12))
- Quickstarter-specific CPU quotas ([#74](https://github.com/opendevstack/ods-quickstarters/issues/74))
- Add 'release-manager.yml' to each quickstarter ([#53](https://github.com/opendevstack/ods-quickstarters/issues/53))
- Enable WSGI for ds-ml-service quickstarter ([#37](https://github.com/opendevstack/ods-quickstarters/issues/37))
- Add central Tailorfile to easily compare resources ([#44](https://github.com/opendevstack/ods-quickstarters/issues/44))

### Changed
- Quickstarters have been renamed for more consistency when they were moved from `ods-project-quickstarters`
- Switch to OAuth proxy in jupyter-notebook and r-shiny quickstarters ([#46](https://github.com/opendevstack/ods-quickstarters/issues/46))
- Airflow Quickstarter fully provisioned in user's ODS project ([#60](https://github.com/opendevstack/ods-quickstarters/issues/60))
- Rename Airflow QuickStarter to `airflow-cluster` ([#76](https://github.com/opendevstack/ods-quickstarters/issues/76))
- Golang agent misses readme ([#64](https://github.com/opendevstack/ods-quickstarters/issues/64))
- Pass image tag and Git ref as params when provisioning quickstarters ([#41](https://github.com/opendevstack/ods-quickstarters/issues/41))
- fe-vue: Use nodejs10 agent for provisioning and building ([#32](https://github.com/opendevstack/ods-quickstarters/issues/32))
- fe-react: Generated Jenkinsfile should use nodejs10 agent image ([#31](https://github.com/opendevstack/ods-quickstarters/issues/31))
- fe-ionic: Use nodejs10 image for provisioning ([#30](https://github.com/opendevstack/ods-quickstarters/issues/30))
- e2e-cypress: Update to nodejs10 image ([#31](https://github.com/opendevstack/ods-quickstarters/issues/31))
- be-spring-boot: added springCliVersion, updated springframework to 2.2.1 ([#40](https://github.com/opendevstack/ods-quickstarters/pull/40))

### Fixed
- Wrong file permission stops Snyk cli from running in Python agent ([#67](https://github.com/opendevstack/ods-quickstarters/issues/67))
- Spring Boot quickstarter ignores property `no_nexus` ([#61](https://github.com/opendevstack/ods-quickstarters/issues/61))
- be-typescript-express: node version in deployment image doesn't match build image ([#8](https://github.com/opendevstack/ods-quickstarters/issues/8))

### Removed
- `NEXUS_HOST` param for component creation ([#70](https://github.com/opendevstack/ods-quickstarters/issues/70))
- Remove nodejs8 agent image ([#54](https://github.com/opendevstack/ods-quickstarters/issues/54))

## [1.2.0 ods-project-quickstarters] - 2019-10-10

### Added

- Add Go Quickstarter ([#255](https://github.com/opendevstack/ods-project-quickstarters/issues/255)).
- Enable xml unit - unit test results on all quickstarters and refactor build stage ([#299](https://github.com/opendevstack/ods-project-quickstarters/issues/299)).
- Airflow Cluster Quickstarter - pipeline ([#307](https://github.com/opendevstack/ods-project-quickstarters/issues/307)).
- ds-ml-service MRO ready ([#373](https://github.com/opendevstack/ods-project-quickstarters/issues/373)).
- Support Java 11 ([#309](https://github.com/opendevstack/ods-project-quickstarters/issues/309)).
- Clone-environment script should allow to pass branch and skip tagging flags ([#292](https://github.com/opendevstack/ods-project-quickstarters/issues/292)).
- ds-ml-service unified docker file ([#272](https://github.com/opendevstack/ods-project-quickstarters/issues/272)).
- Improve SonarQube support on FE quickstarters ([#212](https://github.com/opendevstack/ods-project-quickstarters/issues/212)).
- Create release manager quickstarter ([#391](https://github.com/opendevstack/ods-project-quickstarters/issues/391)).

### Changed

- Quickstarter `be-docker-plain` now builds a running container based on alpine instead of RHEL ([#260](https://github.com/opendevstack/ods-project-quickstarters/issues/260)).
- Quickstarter `ds-ml-service` with unified docker file ([#272](https://github.com/opendevstack/ods-project-quickstarters/issues/272)).
- Update jenkins agent for 1.2.x release ([#356](https://github.com/opendevstack/ods-project-quickstarters/issues/356)).
- Airflow quickstarter needs rundeck and resource limits update ([#358](https://github.com/opendevstack/ods-project-quickstarters/issues/358)).
- ds-ml-service - Train model pipeline step can fail after port forwarding of training service ([#269](https://github.com/opendevstack/ods-project-quickstarters/issues/269)).
- R quickstarter: standard keyserver port 11371 often blocked ([#298](https://github.com/opendevstack/ods-project-quickstarters/issues/298)).
- Replace upload-templates.sh with tailor ([#38](https://github.com/opendevstack/ods-project-quickstarters/issues/38)).
- Polish be-docker-plain ([#264](https://github.com/opendevstack/ods-project-quickstarters/issues/264)).

### Fixed

- Import of images into other cluster fails - because of missing role for default user ([#345](https://github.com/opendevstack/ods-project-quickstarters/issues/345)).
- fe-react: Make sure npm i is run within node docker image ([#363](https://github.com/opendevstack/ods-project-quickstarters/issues/363)).
- fe-react fails to install jest-junit dependency ([#361](https://github.com/opendevstack/ods-project-quickstarters/issues/361)).
- Enable Junit XML output for unit tests fo Vue QS ([#369](https://github.com/opendevstack/ods-project-quickstarters/issues/369)).
- Fix fe-angular quick starter karma config file manipulation ([#378](https://github.com/opendevstack/ods-project-quickstarters/issues/378)).
- Go quickstarter fails with no tests when collecting test results via junit ([#388](https://github.com/opendevstack/ods-project-quickstarters/issues/388)).
- Jupyter quickstarter app: Kernel won't start ([#268](https://github.com/opendevstack/ods-project-quickstarters/issues/268)).
- Error building Python based Quickstarters on OKD ([#295](https://github.com/opendevstack/ods-project-quickstarters/issues/295)).
- Reduce memory ratio ([#277](https://github.com/opendevstack/ods-project-quickstarters/issues/277)).
- be-docker-plain quickstarter fails in initial deployment ([#260](https://github.com/opendevstack/ods-project-quickstarters/issues/260)).
- be-python-flask: build fails when "python-ldap" is added to requirements.txt ([#250](https://github.com/opendevstack/ods-project-quickstarters/issues/250)).

## [1.1.0 ods-project-quickstarters] - 2019-05-28

### Added
- Rundeck `prepare-continous integration` job can now be used to upgrade an existing git repository ([#110](https://github.com/opendevstack/ods-project-quickstarters/pull/110))
- New quickstarter `be-docker-plain`: useful for starting with a plain `Dockerfile` and no BE/FE framework on top ([#97](https://github.com/opendevstack/ods-project-quickstarters/issues/97))
- Maven/Gradle Jenkins agent `jenkins-agent-maven` now gets Nexus credentials injected as server into `settings.xml` ([#127](https://github.com/opendevstack/ods-project-quickstarters/issues/127))
- New quickstarter `ds_ml_service` for machine learning from model training & testing to production ([#111](https://github.com/opendevstack/ods-project-quickstarters/issues/111))
- Quickstarter `be-python-flask` now provides coverage analysis data to SonarQube
- Quickstarter `fe-angular` now provides coverage analysis data to SonarQube and added SonarQube's linter rules for tslint
- Documentation of all quickstarters and agents added

### Changed
- Python quickstarter should use nexus as artifact repo ([#27](https://github.com/opendevstack/ods-project-quickstarters/issues/27))
- Jupyter & R-Shiny quickstarters are now based on new Openresty-based WAF image ([#103](https://github.com/opendevstack/ods-project-quickstarters/pull/103))
- NodeJS 10 Angular Jenkins agent `nodejs10-angular` replaces `nodejs8-angular` and supports nodeJS 10, Angular CLI 8.0.1 and cypress 3.3.1

### Fixed
- Rshiny quickstarter broken - due to refactoring and webhook proxy introduction ([#200](https://github.com/opendevstack/ods-project-quickstarters/issues/200)) & ([#184](https://github.com/opendevstack/ods-project-quickstarters/issues/184))
- Create-projects.sh seeds wrong jenkins SA rights & misses default SA for webhook proxy bug ([#189](https://github.com/opendevstack/ods-project-quickstarters/issus/189))
- import metadata: docker pull secrets are not created in an existing project - breaks oc import-image ([#202](https://github.com/opendevstack/ods-project-quickstarters/issues/202))
- Import Script is not replacing urls for sonarqube in DCs ([#145](https://github.com/opendevstack/ods-project-quickstarters/issues/145))

## [1.0.2 ods-project-quickstarters] - 2019-04-02

### Fixed
- Angular quickstarter `fe-angular-frontend` compilation failed due to changed dependency ([#129](https://github.com/opendevstack/ods-project-quickstarters/issues/129))
- Spring boot quickstarter `be-springboot` gradle build failed due to dependency update to gradle 4.10 ([#131](https://github.com/opendevstack/ods-project-quickstarters/issues/131))
- Upgrade of repo, thru rundeck job `prepare-continous integration` fails with invalid device ([#124](https://github.com/opendevstack/ods-project-quickstarters/issues/124))
- Jenkins `python agent` requires pip to have proper ssl validation configuration ([#176](https://github.com/opendevstack/ods-project-quickstarters/issues/176))

## [1.0.1 ods-project-quickstarters] - 2019-01-25

### Fixed
- Exclude images in `openshift` and `rhscl` namespace on import ([#102](https://github.com/opendevstack/ods-project-quickstarters/pull/102))
- Maven agent fails when proxy is configured due to invalid XML ([#108](https://github.com/opendevstack/ods-project-quickstarters/pull/108))


## [1.0.0 ods-project-quickstarters] - 2018-12-03

### Added
- Spring Boot Jenkins pipeline surfaces test results (#34)
- Jenkins webhook proxy templates (#81, #82)

### Changed
- Quickstarter build containers (located in the subdirs of https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) inherit from corresponding Jenkins build agents now rather than replicating the setup
- Rundeck's OC container inherits from `jenkins-agent-base` now. The pull and tag is triggered thru *verify-rundeck-settings* rundeck job (#32)
- The build of a quickstarter component does not upload the tarball to Nexus anymore - instead it uses binary build configs (#9)
- The containers used to connect to openshift now pull the root ca during build, to ensure SSL trust (#12, #54)
- agents now support HTTP/S proxy - inject as ENV - with HTTP_PROXY, HTTPS_PROXY & NO_PROXY (#50)
- Python agent upgraded to 3.6 latest (#24)
- Maven agent now downloads Gradle 4.8.1 during build to increase build performance of components (#23)
- Scala agent now downloads sbt 1.1.6 / scala 2.12 - given an SBT bug - when proxy set, no NEXUS usage
- Update to newest cypress and TypeScript versions (#91)
- Build Jupyter/Rshiny via Jenkins (#92)

### Fixed
- Nodejs 8 quickstarter failed on npm run coverage (#22)
- Rundeck containers not cleaned up (#16, #17)
- Disable inclusion of Nginx server version in HTTP headers (#79)
- Jupyter: install from Nexus (#65)

### Removed
- Remove broken be-database quickstarter (#87)


## [0.1.0 ods-project-quickstarters] - 2018-07-27

Initial release.
