FROM python:3.8-buster

LABEL maintainer="Andras Gyacsok <andras.gyacsok@boehringer-ingelheim.com>"

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

WORKDIR /app

COPY run.sh /app
COPY dist/* /app/

RUN chown -R 1001:0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh

WORKDIR /app

RUN if [ ! -z ${nexusHostWithBasicAuth} ]; \
    then pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi && \
    pip check

USER 1001

CMD ["./run.sh"]
