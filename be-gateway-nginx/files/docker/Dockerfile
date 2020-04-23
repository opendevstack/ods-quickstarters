# https://github.com/openresty/docker-openresty
FROM openresty/openresty:1.15.8.2-6-alpine-fat

ENV LANG=C.UTF-8

# adding Lua lib dependency for OpenIDConnect (backward compatible for HTTP Basic Auth Crowd)
RUN opm install zmartzone/lua-resty-openidc

WORKDIR /app

COPY lua /usr/local/openresty/lualib
COPY nginx.conf /usr/local/openresty/nginx/conf/
COPY entrypoint.sh /app/

RUN chgrp -R 0 /app /usr/local/openresty/nginx && \
    chmod -R g=u /app /usr/local/openresty/nginx && \
    chmod +x /app/entrypoint.sh && \
    chmod g+w /etc/passwd && \
    rm /etc/nginx/conf.d/default.conf

EXPOSE 8080

USER 1001

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["nginx"]
