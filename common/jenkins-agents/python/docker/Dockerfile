FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

LABEL maintainer="Gerard Castillo <gerard.castillo@boehringer-ingelheim.com>"

ARG nexusHost
ARG nexusAuth

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV PATH=/opt/rh/rh-python36/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/rh-python36/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    MANPATH=/opt/rh/rh-python36/root/usr/share/man:$MANPATH \
    PKG_CONFIG_PATH=/opt/rh/rh-python36/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}} \
    XDG_DATA_DIRS="/opt/rh/rh-python36/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

# Enable rhel-server-rhscl-7-rpms repo
RUN set -x && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --disable rhel-7-server-htb-rpms && \
    yum makecache

# Python 3.6
RUN yum -y install --setopt=tsflags=nodocs yum-utils gcc make openssl-devel zlib-devel sqlite-devel postgresql-devel @development && \
    yum -y install rh-python36 rh-python36-python-tools && \
    yum clean all && \
    rm -rf /var/cache/yum

# If defined, configure PIP with Nexus as default global index, define extra index to public pypi repo and set certs
RUN pip install --upgrade pip && \
    if [ ! -z ${nexusHost} ] && [ ! -z ${nexusAuth} ]; \
    then pip config set global.index-url https://${nexusAuth}@${nexusHost}/repository/pypi-all/simple \
        && pip config set global.trusted-host ${nexusHost} \
        && pip config set global.extra-index-url https://pypi.org/simple; \
    fi; \
    pip config set global.cert /etc/ssl/certs/ca-bundle.crt && \
    pip install virtualenv==20.0.9 setuptools==49.2.0 Cython==0.29.21 pypandoc==1.5

# Enables default user to access $HOME folder
RUN chgrp -R 0 $HOME && \
    chmod -R a+rw $HOME && \
    chown -R 1001 $HOME

USER 1001
