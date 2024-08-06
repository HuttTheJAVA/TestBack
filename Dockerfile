# Stage 1: Build the application
FROM gradle:8.0-jdk17 AS build
WORKDIR /app
COPY . /app
RUN gradle build --no-daemon

# Stage 2: Create a minimal image with the built JAR
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/build/libs/demo-0.0.1-SNAPSHOT.jar /app/demo.jar
ENTRYPOINT ["java", "-jar", "/app/demo.jar"]


