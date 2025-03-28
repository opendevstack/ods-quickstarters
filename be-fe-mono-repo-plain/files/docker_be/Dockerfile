# add /overwrite FROM with your base image, and do whatever you like here :)
FROM registry.redhat.io/ubi9/ubi

RUN echo "building simple backend container"

USER root
 
RUN yum -y update && \
	yum install -y nc && \
	yum clean all
 
USER 1001

EXPOSE 8081

CMD ["/bin/sh", "-c", "/usr/bin/nc -lk -p 8081 --sh-exec \"echo -e 'HTTP/1.1 200 OK\n\nHello World!\n$(date)'\""]
