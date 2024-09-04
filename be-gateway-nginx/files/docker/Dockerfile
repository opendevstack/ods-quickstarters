# https://github.com/openresty/docker-openresty
FROM openresty/openresty:1.25.3.2-0-rocky

ENV LANG=C.UTF-8

# Example: adding Lua lib dependency for OpenIDConnect:
# 1) with OPM
# RUN opm install zmartzone/lua-resty-openidc
# 2) or with LuaRocks
# RUN luarocks install zmartzone/lua-resty-openidc

WORKDIR /app

COPY lua /usr/local/openresty/lualib
COPY nginx.conf /usr/local/openresty/nginx/conf/
COPY entrypoint.sh /app/

RUN dnf upgrade -y && \
    dnf clean all

RUN chgrp -R 0 /app /usr/local/openresty/nginx && \
    chmod -R g=u /app /usr/local/openresty/nginx && \
    chmod +x /app/entrypoint.sh && \
    chmod g+w /etc/passwd && \
    rm /etc/nginx/conf.d/default.conf

EXPOSE 8080

USER 1001

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["nginx"]
