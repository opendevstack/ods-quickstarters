FROM openjdk:8-jre-alpine

WORKDIR /app
COPY target/universal/stage/lib/* /app/lib/
COPY target/universal/stage/conf/ /app/conf/

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.dir=/app", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-cp", "conf/:lib/*"]
CMD ["play.core.server.ProdServerStart"]