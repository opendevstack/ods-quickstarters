#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "configure in memory database in spring application.properties"
echo "spring.profiles.active: dev" > src/main/resources/application.properties
echo "spring.jpa.database: HSQL" > src/main/resources/application-dev.properties

echo "customise build.gradle - getting version"

version=$(grep /gradle-. gradle/wrapper/gradle-wrapper.properties | cut -d "-" -f2)

echo "gradle version: $version"

USE_LEGACY_NEXUS_UPLOAD_SCRIPT=0

if [[ $version == "4.9" ]]; then
	sed -i.bak '/springBootVersion =/a \
	    nexus_url = "\${project.findProperty("nexus_url") ?: System.getenv("NEXUS_HOST")}"\
	    nexus_folder = "candidates"\
	    nexus_user = "\${project.findProperty("nexus_user") ?: System.getenv("NEXUS_USERNAME")}"\
	    nexus_pw = "\${project.findProperty("nexus_pw") ?: System.getenv("NEXUS_PASSWORD")}"\
	' build.gradle

	sed -i.bak "s/\(apply plugin: 'java'\)/\1\napply plugin: 'maven'\napply plugin: 'jacoco'/g" build.gradle

	# by default no jar task in there .. we need to add it.
	echo -e "bootJar {\n    archiveName    \"app.jar\"\n    destinationDir  file(\"\044buildDir/../docker\")\n}" >> build.gradle

	# add nexus
	sed -i.bak 's/mavenCentral()/maven () {\
	        url "${nexus_url}\/repository\/jcenter\/"\
	        credentials {\
	          username = "${nexus_user}"\
	          password = "${nexus_pw}"\
	        }\
	      }\
	\
	      maven () {\
	        url "${nexus_url}\/repository\/maven-public\/"\
	        credentials {\
	          username = "${nexus_user}"\
	          password = "${nexus_pw}"\
	        }\
	      }\
	\
	      maven () {\
	        url "${nexus_url}\/repository\/atlassian_public\/"\
	        credentials {\
	          username = "${nexus_user}"\
	          password = "${nexus_pw}"\
	        }\
	      }\
	/g' build.gradle
	USE_LEGACY_NEXUS_UPLOAD_SCRIPT=1
else
	templateFile=$SCRIPT_DIR/templates/build-$version.gradle
	echo "using $templateFile"
	# this allows quick config, new version - add new template, done
	if [[ -f "$templateFile" ]]; then
		echo "found specific gradle version template"
		mv $templateFile build.gradle
		USE_LEGACY_NEXUS_UPLOAD_SCRIPT=1
	else
		# default
		mv $SCRIPT_DIR/templates/build-4.10.gradle build.gradle
		USE_LEGACY_NEXUS_UPLOAD_SCRIPT=0
	fi
	sed -i.bak "s|__GROUP__|$GROUP|g" build.gradle
fi

rm build.gradle.bak

if [[ $USE_LEGACY_NEXUS_UPLOAD_SCRIPT == 1 ]]; then
  echo "add legacy nexus upload script to build.gradle"
cat >> build.gradle <<EOL
uploadArchives {
    repositories{
        mavenDeployer {
            repository(url: "\${nexus_url}/repository/\${nexus_folder}/") {
                 authentication(userName: "\${nexus_user}", password: "\${nexus_pw}")
            }
            pom.artifactId = '$COMPONENT'
            pom.groupId = '$GROUP'
            pom.version="\${System.getenv("TAGVERSION")}" // we will get a TAGVERSION from environment
        }
    }
}
EOL
else
  echo "do not add legacy nexus upload script to build.gradle"
fi
