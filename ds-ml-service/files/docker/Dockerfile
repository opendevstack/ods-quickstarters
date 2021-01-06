FROM centos/python-38-centos7:latest
# If you want to enable the redhat supported version, uncomment the following line
# and remove the line above
#
#FROM registry.access.redhat.com/rhscl/python-38-rhel7

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme
ARG serviceType

ARG httpProxy
ARG httpsProxy

WORKDIR /app

ENV HTTP_PROXY "${httpProxy}"
ENV HTTPS_PROXY "${httpsProxy}"

ENV DSI_MINICONDA_PACKAGE_PATH=/app/miniconda3.sh
ENV PYTHONPATH=$PYTHONPATH:/app
ENV DSI_PACKAGE=/app/app.tar.gz
ENV SERVICE_TYPE="${serviceType}"

RUN echo "Building ${serviceType} image"

# Front load pip install, miniconda download for caching docker build layers
COPY dist/requirements.txt /app
USER root
#  In the case of building the docker image from behind a proxy and encountering certificate issues, adding a -k to the curl command can mitigate that, consider however the implications of disabling certificate
RUN if [[ ${serviceType} == "training" ]]; \
        then curl -Lv --fail https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh --output ${DSI_MINICONDA_PACKAGE_PATH}; \
            if [[ ! -z ${nexusHostWithBasicAuth} ]]; \
                then  pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} pytest pytest-cov; \
                else pip install --upgrade pip && pip install pytest pytest-cov; \
            fi \
    fi

USER 1001
RUN if [[ ! -z ${nexusHostWithBasicAuth} ]]; \
    then  pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi

RUN pip check

# Copying all the code
COPY dist /app

USER root

# Is needed that the special user (1001) has the permissions for starting python servers
RUN chgrp -R 0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh && \
    chmod g+w /etc/passwd

RUN if [[ ${serviceType} == "training" ]]; \
    then touch /app/app.tar.gz && tar zcf /app/app.tar.gz ./ --exclude=./app.tar.gz; \
    fi

USER 1001

EXPOSE 8080

ENTRYPOINT [ "./run.sh" ]
