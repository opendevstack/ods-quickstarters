FROM registry.access.redhat.com/ubi8/openjdk-11:1.14

WORKDIR /app
COPY lib/* /app/lib/
COPY conf /app/conf/

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.dir=/app", "-XX:+UnlockExperimentalVMOptions", "-cp", "conf/:lib/*"]
CMD ["play.core.server.ProdServerStart"]
