# add /overwrite FROM with your base image, and do whatever you like here :)
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

RUN echo "Building simple container"

USER root

RUN microdnf -y update && \
    microdnf clean all

USER 1001

EXPOSE 8080

CMD ["sh", "-c", "while true; do echo 'Container running on port 8080'; sleep 5; done"]
