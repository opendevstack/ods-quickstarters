FROM adoptopenjdk/openjdk8:ubi-minimal-jre

WORKDIR /app
COPY lib/* /app/lib/
COPY conf /app/conf/

EXPOSE 8080

ENTRYPOINT ["java", "-Duser.dir=/app", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-cp", "conf/:lib/*"]
CMD ["play.core.server.ProdServerStart"]
