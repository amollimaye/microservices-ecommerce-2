# Start with a base image containing Java runtime
FROM eclipse-temurin:17-jdk-alpine

# Add Maintainer Info
LABEL maintainer="amollimaye"

# Add a volume pointing to /tmp
VOLUME /tmp

EXPOSE 8090

RUN addgroup -S spring && adduser -S spring -G spring

ARG JAR_FILE=target/ecommerce-0.0.1-SNAPSHOT.jar

ADD ${JAR_FILE} ecommerce.jar
RUN chown spring:spring /ecommerce.jar

USER spring

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/ecommerce.jar"]
