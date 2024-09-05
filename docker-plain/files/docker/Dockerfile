# add /overwrite FROM with your base image, and do whatever you like here :)
FROM alpine:latest

RUN echo "building simple container"

RUN apk update  && \
    apk -i upgrade && \
    apk cache clean

EXPOSE 8080

CMD ["/bin/sh", "-c", "/usr/bin/nc -lk -p 8080 -e echo -e \"HTTP/1.1 200 OK\n\nHello World!\n$(date)\""]
