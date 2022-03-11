SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

SOURCE_DIR=${sourceDir}
TARGET_DIR=${targetDir}
SPRING_BOOT_CLI_VERSION=${springBootVersion}
PROJECT_ID=${projectId}
COMPONENT_ID=${componentId}
PACKAGE_NAME=${packageName}

# create-project
create-project:
	mkdir -p ${TARGET_DIR}
	cd ${TARGET_DIR} && curl https://start.spring.io/starter.tgz \
            -d type=gradle-project \
            -d language=java \
            -d dependencies='web,jersey,data-jpa,h2,data-rest,restdocs,security' \
            -d bootVersion=${SPRING_BOOT_CLI_VERSION} \
            -d packaging=jar \
            -d javaVersion=17 \
            -d groupId=${PROJECT_ID} \
            -d artifactId=${COMPONENT_ID} \
            -d name=${COMPONENT_ID} \
            -d description='OpenDevStack%20Demo%20Project%20for%20Spring%20Boot' \
            -d packageName='${PACKAGE_NAME}' \
            | tar -zxvf -

.PHONY: create-project
# add-sb-app-properties
add-sb-app-properties:
	echo 'spring.profiles.active: dev' > ${TARGET_DIR}/src/main/resources/application.properties
	echo 'spring.jpa.database: HSQL' > ${TARGET_DIR}/src/main/resources/application-dev.properties
.PHONY: add-sb-app-properties
# customise-build-gradle
customise-build-gradle:
	echo "called customise-build-gradle..."

	echo "...enforce minimal log4j2 version to avoid (CVE-2021-44228)"
	sed -i -e '/ext {/{r ${SOURCE_DIR}/templates/gradle-minimal-log4j2-version.template' -e 'd' -e '}' ${TARGET_DIR}/build.gradle

	echo "...add nexus credential settings"
	cat ${SOURCE_DIR}/templates/gradle-buildscript.template ${TARGET_DIR}/build.gradle >out && mv out ${TARGET_DIR}/build.gradle

	echo "...insert required plugins"
	sed -i -e '/plugins {/{r ${SOURCE_DIR}/templates/gradle-plugins.template' -e 'd' -e '}' ${TARGET_DIR}/build.gradle

	echo "...insert nexus repos"
	sed -i -e '/mavenCentral()/{r ${SOURCE_DIR}/templates/gradle-repositories.template' -e 'd' -e '}' ${TARGET_DIR}/build.gradle

	echo "...insert test settings"
	sed -i -e '/test {/{r ${SOURCE_DIR}/templates/gradle-plugin-test.template' -e 'd' -e '}' ${TARGET_DIR}/build.gradle

	echo "...append bootJar settings"
	cat ${SOURCE_DIR}/templates/gradle-plugin-bootjar.template >> ${TARGET_DIR}/build.gradle

	echo "...append jacoco settings"
	cat ${SOURCE_DIR}/templates/gradle-plugin-jacoco.template >> ${TARGET_DIR}/build.gradle

	echo "...append maven-publish settings"
	cat ${SOURCE_DIR}/templates/gradle-maven-publish.template >> ${TARGET_DIR}/build.gradle

.PHONY: customise-build-gradle

