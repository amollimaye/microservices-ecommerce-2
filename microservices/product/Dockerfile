# Start with a base image containing Java runtime
FROM eclipse-temurin:17-jdk-alpine

# Add Maintainer Info
LABEL maintainer="amollimaye"

# Add a volume pointing to /tmp
VOLUME /tmp

EXPOSE 8090

RUN addgroup -S spring && adduser -S spring -G spring

ARG JAR_FILE=target/product-service-0.0.1-SNAPSHOT.jar

ADD ${JAR_FILE} product-service.jar
RUN chown spring:spring /product-service.jar

USER spring

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/product-service.jar"]
