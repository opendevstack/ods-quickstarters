FROM registry.redhat.io/ubi9/nodejs-22

COPY dist /node

USER root
 
RUN yum -y update && \
	yum clean all

RUN chown -R node: /node

EXPOSE 8080

USER node

WORKDIR /node

CMD ["node", "dist/src/index.js"]
