FROM adoptopenjdk/openjdk11:alpine-jre

COPY app.jar app.jar

EXPOSE 8080

CMD ["java","-Xmx512m", "-jar", "app.jar"]
