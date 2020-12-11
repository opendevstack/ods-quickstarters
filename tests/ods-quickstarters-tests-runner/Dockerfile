FROM golang:1.15.2

# Configure any corportate proxies if needed 
# ENV http_proxy <SET_VALUE> 
# ENV https_proxy <SET_VALUE>
# ENV HTTP_PROXY <SET_VALUE> 
# ENV HTTPS_PROXY <SET_VALUE>

RUN go get -u github.com/jstemmer/go-junit-report

RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar -xzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit && \
    chmod +x ./oc && \
    mv ./oc /usr/bin && \
    mv ./kubectl /usr/bin && \
    rm -rf openshift-origin-client-tools-*

RUN apt-get update -y && \
    apt-get install -y jq    

WORKDIR /work

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
