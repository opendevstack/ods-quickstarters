# Changelog

## Unreleased

### Added

- Use Java 17 (LTS) in maven jenkins-agent and spring boot qs ([#651](https://github.com/opendevstack/ods-quickstarters/pull/651))
- ODS AMI build fails due to failing jacoco report generation in springboot quickstarter ([#700](https://github.com/opendevstack/ods-quickstarters/pull/700))
- terraform agent sops/age added ([#730](https://github.com/opendevstack/ods-quickstarters/issues/730))

### Fixed

- Mavent agent updated from Jenkins base image changes ([#722](https://github.com/opendevstack/ods-quickstarters/issues/722))
- NodeJS12 agent updated from Jenkins base image changes ([#720](https://github.com/opendevstack/ods-quickstarters/issues/720))
- Scala agent updated from Jenkins base image changes ([#721](https://github.com/opendevstack/ods-quickstarters/issues/721))
- terraform agent updated from Jenkins base image changes ([#724](https://github.com/opendevstack/ods-quickstarters/issues/724))
- Bump antora page version in master (https://github.com/opendevstack/ods-documentation/issues/66)
- Default acceptance test in Spock makes the pipeline runs forever ([#706](https://github.com/opendevstack/ods-quickstarters/issues/706))

### Modified

- Added azure-cli to terraform agent ([#628](https://github.com/opendevstack/ods-quickstarters/issues/628))
- Add JVM parameters on docgen deployment ([#669](https://github.com/opendevstack/ods-quickstarters/pull/669))
- Updates maven agent to support only HTTPS proxy ([#689])(https://github.com/opendevstack/ods-quickstarters/issues/689))
- Fix error handling of Makefile ([#680](https://github.com/opendevstack/ods-quickstarters/issues/680))
- Add missing directory ([#679](https://github.com/opendevstack/ods-quickstarters/issues/679))
- Rewrote the Cloud Formation Stack Example ([#683](https://github.com/opendevstack/ods-quickstarters/issues/683))
- Enforce use of secure Log4j version in SpringBoot Quickstarter ([#693](https://github.com/opendevstack/ods-quickstarters/issues/693))
- inf-terraform-aws: Update versions for ruby, terraform, kitchen-terraform, Gemfile ([#677](https://github.com/opendevstack/ods-quickstarters/issues/677))
- jupyter lab: reduction to a minimal initial env ([#710](https://github.com/opendevstack/ods-quickstarters/issues/710))

## [4.0] - 2021-05-11

### Added
- ds-rshiny cleanup cloudera dependency ([#540](https://github.com/opendevstack/ods-quickstarters/pull/540))
- Add SaaS documentation quickstarter ([#556](https://github.com/opendevstack/ods-quickstarters/pull/556))
- Documented the metadata file and its relationship with the labeling functionality ([#638](https://github.com/opendevstack/ods-quickstarters/pull/638))
- requests access logging enabled for openshift oauth proxy component (used by ds-rshiny and ds-jupyter-lab) ([#590](https://github.com/opendevstack/ods-quickstarters/issues/590))
- e2e-cypress: Added support for login with Azure SSO + MSALv2 ([#601](https://github.com/opendevstack/ods-quickstarters/pull/601))
- terraform jenkins agent: Added AWS SAM CLI and AWS CDK ([#608](https://github.com/opendevstack/ods-quickstarters/pull/608))

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
