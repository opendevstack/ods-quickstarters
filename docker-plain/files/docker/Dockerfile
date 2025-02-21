# this is a sample Dockerfile with nginx as example, you can use it as a reference to create your own custom image
FROM public.ecr.aws/nginx/nginx-unprivileged:alpine-slim

ENV NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE=set

# nginx config file
COPY default.conf /etc/nginx/conf.d/
