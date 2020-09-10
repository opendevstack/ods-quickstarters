FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-agent-nodejs-rhel7-docker" \
      name="openshift3/jenkins-agent-nodejs-rhel7" \
      version="3.6" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins agent Nodejs" \
      io.k8s.description="The jenkins agent nodejs image has the nodejs tools on top of the jenkins agent base image." \
      io.openshift.tags="openshift,jenkins,agent,nodejs"

ARG nexusUrl
ARG nexusAuth

ENV NODEJS_VERSION=12 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install NodeJS
# https://github.com/nodesource/distributions#installation-instructions-1
RUN curl --silent --location https://rpm.nodesource.com/setup_12.x | bash - && \
    yum install -y nodejs && \
    yum install -y gcc-c++ make

# Install Yarn
# https://classic.yarnpkg.com/en/docs/install/#centos-stable
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    yum install -y yarn && \
    yum clean all -y

RUN npm config set registry=$nexusUrl/repository/npmjs/ && \
    npm config set always-auth=true && \
    npm config set _auth=$(echo -n $nexusAuth | base64) && \
    npm config set email=no-reply@opendevstack.org && \
    npm config set ca=null && \
    npm config set strict-ssl=false && \
    yarn config set registry $nexusUrl/repository/npmjs/ -g && \
    echo node version: $(node --version) && \
    echo npm version: $(npm --version) && \
    echo npx version: $(npx --version) && \
    echo yarn version: $(yarn --version)

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME
USER 1001
