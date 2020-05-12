#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ..

while [[ "$#" > 0 ]]; do case $1 in
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;

  -g=*|--group=*) GROUP="${1#*=}";;
  -g|--group) GROUP="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done


echo "generate project from local template"
   sbt -v new file://$SCRIPT_DIR/akka-http-quickstart-scala.g8 --name=$COMPONENT
 
cd $COMPONENT 

# add assembly plugin for fast jar otherwise sbt assembly fails
echo "addSbtPlugin(\"com.eed3si9n\" % \"sbt-assembly\" % \"0.14.5\")" >> project/plugins.sbt
echo "addSbtPlugin(\"com.typesafe.sbt\" % \"sbt-native-packager\" % \"1.3.2\")" >> project/plugins.sbt

# add output path for assembly
echo "enablePlugins(JavaAppPackaging)" >> build.sbt
echo "assemblyOutputPath in assembly := file(\"docker/sclapp.jar\")" >> build.sbt
