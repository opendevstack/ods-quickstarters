FROM kong:1.4-centos

LABEL description="Centos 7 + Kong 1.4 + kong-oidc plugin"

ENV KONG_DATABASE=off
ENV KONG_DECLARATIVE_CONFIG=/config/kong.yml

RUN cp /etc/kong/kong.conf.default /etc/kong/kong.conf
RUN yum install -y git unzip epel-release
RUN yum install -y jq \
    && yum clean all

#Set directory rights
RUN chown -R kong /usr/local/kong \
	&& chgrp -R 0 /usr/local/kong \
	&& chmod -R g=u /usr/local/kong

RUN luarocks install kong-oidc
ENV KONG_PLUGINS=bundled,oidc

#Set log location
ENV KONG_PROXY_ACCESS_LOG="/dev/stdout"
ENV KONG_ADMIN_ACCESS_LOG="/dev/stdout"
ENV KONG_PROXY_ERROR_LOG="/dev/stderr"
ENV KONG_ADMIN_ERROR_LOG="/dev/stderr"


