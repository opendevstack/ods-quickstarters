FROM registry.access.redhat.com/ubi9/openjdk-21

# Enforce runtime protection for log4j2 CVE-2021-44228 (affected version from 2.0 to 2.14.1) in the affected vesion is used.
# This applies for version from 2.10 and not below.
ENV LOG4J_FORMAT_MSG_NO_LOOKUPS=true

COPY app.jar app.jar

USER root

RUN microdnf upgrade -y && \
    microdnf clean all

USER 1001    

EXPOSE 8080

CMD ["java","-Xmx512m", "-jar", "app.jar"]
