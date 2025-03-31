# add /overwrite FROM with your base image, and do whatever you like here :)
FROM registry.access.redhat.com/ubi9/ubi-micro:latest

RUN echo "building simple backend container"

EXPOSE 8081

CMD ["sh", "-c", "while true; do echo 'Container running on port 8081'; sleep 5; done"]
