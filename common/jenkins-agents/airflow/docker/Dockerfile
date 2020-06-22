FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

LABEL maintainer="Gerard Castillo <gerard.castillo@boehringer-ingelheim.com>"

ARG nexusUrl
ARG nexusAuth
ARG airflowVersion=1.10.3

ENV AIRFLOW_HOME=$HOME/airflow
ENV AIRFLOW_GPL_UNIDECODE yes
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

ENV PATH=$HOME/node_modules/.bin:/opt/rh/rh-nodejs8/root/usr/bin:/opt/rh/rh-python36/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/rh-nodejs8/root/usr/lib64:/opt/rh/rh-python36/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    MANPATH=/opt/rh/rh-nodejs8/root/usr/share/man:/opt/rh/rh-python36/root/usr/share/man:$MANPATH \
    PKG_CONFIG_PATH=/opt/rh/rh-python36/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}} \
    XDG_DATA_DIRS="/opt/rh/rh-python36/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable
COPY contrib/npmrc $HOME/.npmrc

# Enable rhel-server-rhscl-7-rpms repo
RUN set -x && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --disable rhel-7-server-htb-rpms && \
    yum makecache

# Python 3.6 and NodeJS 8
RUN yum -y install @development && \
    yum -y install rh-nodejs8 && \
    yum -y install rh-python36 && \
    yum -y install rh-python36-numpy \
                    rh-python36-scipy \
                    rh-python36-python-tools \
                    rh-python36-python-six

# Configuring npm
RUN sed -i "s|NEXUS_URL|$nexusUrl|g" $HOME/.npmrc && \
    sed -i "s|NEXUS_AUTH|$(echo -n $nexusAuth | base64)|g" $HOME/.npmrc && \
    npm config set ca=null && \
    npm config set strict-ssl=false

# Upgrade pip and npm
RUN pip install --upgrade pip && \
    pip -V && \
    pip install virtualenv pycodestyle

# Configure pip SSL validation
RUN pip config set global.cert /etc/ssl/certs/ca-bundle.crt && \
    pip config list

# Airflow
RUN buildDeps=' \
        freetds-devel \
        krb5-devel \
        cyrus-sasl-devel \
        openssl-devel \
        libffi-devel \
        postgresql-devel \
        mariadb-devel \
        git \
    ' \
    && pipDeps="\
       pytz==2019.3 \
       pyOpenSSL==19.1.0 \
       paramiko==2.7.1 \
       sshtunnel==0.1.5 \
       ndg-httpsclient==0.5.1 \
       pyasn1==0.4.8 \
       requests-oauthlib==1.3.0 \
       unittest-xml-reporting==3.0.2 \
       apache-airflow[crypto,postgres,hive,jdbc,mysql,ssh,kubernetes,elasticsearch${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${airflowVersion} \
    " \
    && airflowFixDeps="redis==3.4.1 flask==1.0.1 jinja2==2.10.0 werkzeug==0.14.1" \
    && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install --assumeyes \
        $buildDeps \
        freetds \
        mariadb-libs \
        curl \
        rsync \
        nmap-ncat \
    && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
    && if [[ -n ${nexusUrl} ]]; then \
        nexusName=$(echo -n ${nexusUrl} | sed -E "s|https?://||") && \
        nexusUrl=$(echo -n ${nexusUrl} | sed -e "s|://|://${nexusAuth}@|") && \
        echo "nexusName is ${nexusName}, nexusUrl is ${nexusUrl}" && \
        python3 -m pip install -U --trusted-host ${nexusName} -i ${nexusUrl}/repository/pypi-all/simple pip setuptools wheel \
        && python3 -m pip install --trusted-host ${nexusName} -i ${nexusUrl}/repository/pypi-all/simple $pipDeps \
        && python3 -m pip install --trusted-host ${nexusName} -i ${nexusUrl}/repository/pypi-all/simple $airflowFixDeps; \
    else pip install -U pip setuptools wheel \
        && pip install $pipDeps \
        && pip install $airflowFixDeps; \
    fi \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME
