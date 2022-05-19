#!/bin/bash

function msg_and_exit() {
  echo "ERROR: ${1}"
  exit 1
}

echo "Switching to java 17:"
exactVersion=$(ls -lah /usr/lib/jvm | grep "java-17-openjdk-17.*\.x86_64" | awk '{print $NF}' | head -1)
alternatives --set java /usr/lib/jvm/${exactVersion}/bin/java || msg_and_exit "Cannot configure java 17 as the alternative to use for java."
java -version 2>&1 | grep -q 17 || msg_and_exit "Java version is not 17."

if [ -x /usr/lib/jvm/${exactVersion}/bin/javac ]; then
  alternatives --set javac /usr/lib/jvm/${exactVersion}/bin/javac || msg_and_exit "Cannot configure javac 17 as the alternative to use for javac."
  javac -version 2>&1 | grep -q 17 || msg_and_exit "Javac version is not 17."
fi

java -version
if which 'javac'; then
  javac -version
else
  echo "WARNING: Binary javac is not available."
fi
echo "JAVA_HOME: $JAVA_HOME"
