FROM registry.access.redhat.com/ubi9/python-312

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

ARG HTTPS_PROXY
ARG HTTP_PROXY
ARG NO_PROXY

ENV https_proxy=${HTTPS_PROXY}
ENV http_proxy=${HTTP_PROXY}
ENV no_proxy=${NO_PROXY}

ENV LANG=C.UTF-8

USER root
RUN mkdir -p /app && \
	mkdir -p /app/.streamlit

RUN yum -y update && \
    yum clean all

RUN chown -R 1001:0 /app && \
    chmod -R g=u /app
    
WORKDIR /app

# Install OS dependencies and update certs
RUN openssl s_client -showcerts -host ${nexusHostWithoutScheme} -port 443  </dev/null| \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/pki/ca-trust/source/anchors/oc_app.crt && \
    update-ca-trust
 
# Set all certificates for python
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt
ENV SSL_CERT_DIR=/etc/ssl/certs/
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt

# Install python dependencies and load new certs to certifi
COPY requirements.txt /app

RUN if [ ! -z ${nexusHostWithBasicAuth} ]; \
    then pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi && \
    pip check

# Set certificates for python modules not looking at env vars
RUN cat $REQUESTS_CA_BUNDLE >> $(echo -e "import certifi\nprint(certifi.where())" | python)

# Copy source code
COPY src /app/src

# Copy streamlit theme
COPY src/.streamlit/config.toml /app/.streamlit/config.toml

# deactivate internet access by default
ENV HTTPS_PROXY=
ENV HTTP_PROXY=
ENV https_proxy=
ENV http_proxy=

USER 1001

# include all python pacakges written in src to PYTHONPATH
ENV PYTHONPATH=/app/src:$PYTHONPATH

ENV HOME=/app

CMD ["streamlit",  "run", "/app/src/main.py", "--server.port", "8080", "--browser.serverAddress", "0.0.0.0", "--browser.gatherUsageStats", "False"]
