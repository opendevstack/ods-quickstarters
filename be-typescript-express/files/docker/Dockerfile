FROM registry.redhat.io/ubi9/nodejs-22-minimal

COPY dist /node

USER root

RUN microdnf -y update && \
    microdnf clean all

EXPOSE 8080

USER node

WORKDIR /node

CMD ["node", "dist/src/index.js"]
