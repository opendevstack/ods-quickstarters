# add /overwrite FROM with your base image, and do whatever you like here :)
FROM alpine:latest

RUN echo "building simple backend container"

RUN apk update  && \
    apk -i upgrade && \
    apk cache clean

EXPOSE 8081

CMD ["/bin/sh", "-c", "/usr/bin/nc -lk -p 8081 -e echo -e \"HTTP/1.1 200 OK\n\nHello World!\n$(date)\""]
