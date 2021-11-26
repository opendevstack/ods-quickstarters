echo "Switching to java 11:"
exactVersion=$(ls -lah /usr/lib/jvm | grep "java-11-openjdk-11.*\.x86_64" | awk '{print $NF}' | head -1) && \
alternatives --set java /usr/lib/jvm/${exactVersion}/bin/java && \
alternatives --set javac /usr/lib/jvm/${exactVersion}/bin/javac && \
java -version
javac -version
