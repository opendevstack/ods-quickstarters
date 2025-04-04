FROM public.ecr.aws/nginx/nginx:1.27.4-alpine

RUN apk update  && \
    apk -i upgrade && \
    apk cache clean

RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx \
     # set to 1 as we run the pod with less than a CPU core
     && sed -i 's/worker_processes .*/worker_processes 1;/' /etc/nginx/nginx.conf

COPY dist /docroot
COPY nginx.vh.default.conf.nginx /etc/nginx/conf.d/default.conf

RUN chown -R nginx: /docroot

EXPOSE 8080
