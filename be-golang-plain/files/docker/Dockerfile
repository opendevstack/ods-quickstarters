FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

COPY app_linux_amd64 app_linux_amd64

USER root

RUN microdnf -y update && \
    microdnf clean all

USER 1001

EXPOSE 8080

CMD ["./app_linux_amd64"]
