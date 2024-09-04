FROM registry.access.redhat.com/ubi9/ubi-micro:latest

COPY app /usr/local/bin/app

RUN yum -y update && \
    yum clean all

CMD [ "app" ]
