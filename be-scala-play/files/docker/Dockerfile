FROM registry.access.redhat.com/ubi8/openjdk-11-runtime:1.15

WORKDIR /app
COPY lib/* /app/lib/
COPY conf /app/conf/

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.dir=/app", "-XX:+UnlockExperimentalVMOptions", "-cp", "conf/:lib/*"]
CMD ["play.core.server.ProdServerStart"]
