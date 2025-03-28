# add /overwrite FROM with your base image, and do whatever you like here :)
FROM registry.redhat.io/ubi9-minimal

RUN echo "building simple frontend container"

USER root
 
RUN microdnf -y update && \
	microdnf install -y nc && \
    microdnf clean all
 
USER 1001

EXPOSE 8080

CMD ["/bin/sh", "-c", "/usr/bin/nc -lk -p 8080 --sh-exec \"echo -e 'HTTP/1.1 200 OK\n\nHello World!\n$(date)'\""]
