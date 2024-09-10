FROM nginx:1.27.1-alpine

RUN apk update  && \
    apk -i upgrade && \
    apk cache clean

RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx

COPY dist /docroot
COPY nginx.vh.default.conf.nginx /etc/nginx/conf.d/default.conf

RUN chown -R nginx: /docroot

EXPOSE 8080
