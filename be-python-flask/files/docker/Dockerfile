FROM python:3.7.0-slim

LABEL maintainer="Andras Gyacsok <andras.gyacsok@boehringer-ingelheim.com>"

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ARG projectHome=/opt/app-root/src
ARG home=${projectHome}
ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

RUN set -ex  && \
    # DEPENDENCIES
    buildDeps=' \
        build-essential \
        python3-dev \
        python3-pip \
        zlib1g-dev \
        automake \
        make \
        libtool \
        m4 \
        automake \
        gettext \
    ' && \
    apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq --no-install-recommends \
        $buildDeps \
        apt-utils \
        locales \
        pkg-config && \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    # PROJECT
    mkdir /opt/app-root && \
    useradd -ms /bin/bash -d ${projectHome} -u 1001 prophet && \
    # CLEAN UP
    apt-get autoremove -yqq --purge && \
    apt-get clean

COPY run.sh ${projectHome}
COPY dist ${projectHome}

RUN chown -R prophet: ${projectHome} && \
    chgrp -R 0 ${projectHome} && \
    chmod -R g=u ${projectHome} && \
    chmod g=u /etc/passwd && \
    chmod +x ${projectHome}/run.sh

EXPOSE 8080

ENV HOME=${projectHome}
WORKDIR ${projectHome}

RUN if [ ! -z ${nexusHostWithBasicAuth} ]; \
    then pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r src/requirements.txt; \
    else pip install --upgrade pip && pip install -r src/requirements.txt; \
    fi

USER 1001

CMD ["./run.sh"]
