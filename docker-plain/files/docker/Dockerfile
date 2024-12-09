FROM public.ecr.aws/nginx/nginx-unprivileged:alpine-slim

ENV NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE=set

COPY default.conf /etc/nginx/conf.d/
