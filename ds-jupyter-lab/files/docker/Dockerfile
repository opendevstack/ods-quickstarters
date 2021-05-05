FROM registry.access.redhat.com/ubi8/python-38

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
    fi && \
    pip check

USER root

COPY run.sh /opt/app-root/run.sh
COPY jupyter_lab_config.json /opt/app-root/src/.jupyter/jupyter_lab_config.json

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
