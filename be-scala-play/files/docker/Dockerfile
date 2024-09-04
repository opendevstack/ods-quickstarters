FROM registry.access.redhat.com/ubi9/openjdk-11-runtime:1.20

WORKDIR /app
COPY lib/* /app/lib/
COPY conf /app/conf/

RUN yum -y update && \
    yum clean all

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.dir=/app", "-XX:+UnlockExperimentalVMOptions", "-cp", "conf/:lib/*"]
CMD ["play.core.server.ProdServerStart"]
