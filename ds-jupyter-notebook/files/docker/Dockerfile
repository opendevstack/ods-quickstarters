FROM centos/python-36-centos7:latest
# If you want to enable the redhat supported version, uncomment the following line
# and remove the line above
#
#FROM registry.access.redhat.com/rhscl/python-36-rhel7

LABEL maintainer="Stefan Klingelschmitt <stefan.klingelschmitt@boehringer-ingelheim.com>"

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

WORKDIR /opt/app-root/src

ENV PYTHONPATH=$PYTHONPATH:/opt/app-root/src \
    NPM_CONFIG_PREFIX=/opt/app-root \
    NODE_OPTIONS=--max-old-space-size=4096

COPY requirements.txt /opt/app-root/src

USER 1001
# From load pip install for caching docker build layers
RUN if [ ! -z ${nexusHostWithBasicAuth} ]; \
    then pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi

USER root

COPY run.sh /opt/app-root/run.sh
COPY jupyter_notebook_config.json /opt/app-root/src/.jupyter/jupyter_notebook_config.json

RUN chown -R 1001 /opt/app-root/src && \
    chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u /opt/app-root/src && \
    chmod +x /opt/app-root/run.sh && \
    chmod g+w /etc/passwd && \
    chmod -R g+w /opt/app-root/share && \
    chmod -R g+w /opt/app-root/src

USER 1001

EXPOSE 8080

ENTRYPOINT [ "/opt/app-root/run.sh" ]

CMD [ "jupyter", "lab" ]
