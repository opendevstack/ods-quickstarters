FROM registry.access.redhat.com/ubi9/openjdk-17-runtime:latest

WORKDIR /app
COPY lib/* /app/lib/
COPY conf /app/conf/

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.dir=/app", "-XX:+UnlockExperimentalVMOptions", "-cp", "conf/:lib/*"]
CMD ["play.core.server.ProdServerStart"]
