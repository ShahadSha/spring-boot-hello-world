FROM maven:3.6.1-jdk-8-alpine as Build
COPY /src ./src
COPY /pom.xml /pom.xml
RUN mvn clean install

FROM openjdk:8u171-jre-alpine
COPY --from=Build ./target/hello-world-*.jar ./hello-world.jar
CMD ["java", "-jar", "./hello-world.jar"]
EXPOSE 6789