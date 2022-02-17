echo "Switching to java 17:"
exactVersion=$(ls -lah /usr/lib/jvm | grep "java-17-openjdk-17.*\.x86_64" | awk '{print $NF}' | head -1) && \
alternatives --set java /usr/lib/jvm/${exactVersion}/bin/java && \
alternatives --set javac /usr/lib/jvm/${exactVersion}/bin/javac && \
java -version
javac -version
