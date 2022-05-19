#!/bin/bash

echo "Switching to java 11:"
exactVersion=$(ls -lah /usr/lib/jvm | grep "java-11-openjdk-11.*\.x86_64" | awk '{print $NF}' | head -1)
alternatives --set java /usr/lib/jvm/${exactVersion}/bin/java || exit 1
java -version | grep -q 11 || exit 1

if [ -x /usr/lib/jvm/${exactVersion}/bin/javac ]; then
  alternatives --set javac /usr/lib/jvm/${exactVersion}/bin/javac || exit 1
  javac -version | grep -q 11 || exit 1
fi

java -version
javac -version
echo "JAVA_HOME: $JAVA_HOME"
