# add /overwrite FROM with your base image, and do whatever you like here :)
FROM registry.redhat.io/ubi9-micro

RUN echo "building simple backend container"

EXPOSE 8081

CMD ["sh", "-c", "while true; do echo 'Container running on port 8081'; sleep 5; done"]
