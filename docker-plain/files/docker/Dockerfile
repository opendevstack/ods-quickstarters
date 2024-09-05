# add /overwrite FROM with your base image, and do whatever you like here :)
FROM nginxinc/nginx-unprivileged:latest

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get clean

USER 1001
