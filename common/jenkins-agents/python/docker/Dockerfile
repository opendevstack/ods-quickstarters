FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

LABEL maintainer="Gerard Castillo <gerard.castillo@boehringer-ingelheim.com>"

ARG nexusHost
ARG nexusAuth

ENV PYTHON_VERSION=3.6.10
ENV VENV_VERSION=20.0.9
ENV INSTALL_PKGS="yum-utils gcc make openssl-devel zlib-devel sqlite-devel"

RUN set -x \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN cd /tmp \
    && curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar xzf Python-${PYTHON_VERSION}.tgz -C / \
    && rm -rf Python-${Python_VERSION}.tgz

RUN cd /Python-${PYTHON_VERSION} \
    && ./configure \
    && make altinstall \
    && ln -s /Python-${PYTHON_VERSION}/python /usr/local/sbin/python3 \
    && python3 -V \
    && chmod a+rx /Python-${PYTHON_VERSION} \
    && chmod a+rx /Python-${PYTHON_VERSION}/python \
    && yum remove -y $INSTALL_PKGS

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
    && python3 get-pip.py

# If defined, configure PIP with Nexus as default global index, define extra index to public pypi repo and set certs
RUN if [ ! -z ${nexusHost} ] && [ ! -z ${nexusAuth} ]; \
    then pip config set global.index-url https://${nexusAuth}@${nexusHost}/repository/pypi-all/simple \
        && pip config set global.trusted-host ${nexusHost} \
        && pip config set global.extra-index-url https://pypi.org/simple; \
    fi; \
    pip config set global.cert /etc/ssl/certs/ca-bundle.crt

# Upgrade PIP
RUN pip3 install --upgrade pip \
    && pip3 -V \
    && pip3 install virtualenv==${VENV_VERSION}

# Enables default user to access $HOME folder
RUN chgrp -R 0 $HOME && \
    chmod -R g+rw $HOME
