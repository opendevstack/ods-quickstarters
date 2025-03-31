# add /overwrite FROM with your base image, and do whatever you like here :)
FROM registry.redhat.io/ubi9-micro

RUN echo "building simple frontend container"

EXPOSE 8080

CMD ["sh", "-c", "while true; do echo 'Container running on port 8080'; sleep 5; done"]
