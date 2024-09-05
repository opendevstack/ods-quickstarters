FROM registry.access.redhat.com/ubi9/python-312

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

COPY app /app
COPY run.sh /app/

WORKDIR /app

USER root

RUN yum -y update && \
    yum clean all

USER 1001

RUN if [ ! -z ${nexusHostWithBasicAuth} ]; \
    then pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi && \
    pip check

USER root
RUN chown -R 1001:0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh

USER 1001

CMD ["./run.sh"]
