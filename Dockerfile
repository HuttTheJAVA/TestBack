# Step 1: Use a Maven base image to build the application
FROM krmp-d2hub-idock.9rum.cc/goorm/gradle:7.3.1-jdk17

# 작업 디렉토리 설정
WORKDIR /home/gradle/project


# Spring 소스 코드를 이미지에 복사
COPY . .

# gradle 빌드 시 proxy 설정을 gradle.properties에 추가
RUN echo "systemProp.http.proxyHost=krmp-proxy.9rum.cc\nsystemProp.http.proxyPort=3128\nsystemProp.https.proxyHost=krmp-proxy.9rum.cc\nsystemProp.https.proxyPort=3128" > /root/.gradle/gradle.properties

# gradlew를 이용한 프로젝트 필드
RUN ./gradlew clean build

# DATABASE_URL을 환경 변수로 삽입
ENV DATABASE_URL=jdbc:mariadb://mariadb/krampoline

# Step 7: Set the working directory
WORKDIR /app

# Step 8: Copy the built application from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Step 9: Expose the application port
EXPOSE 8080

# 빌드 결과 jar 파일을 실행
CMD ["java", "-jar", "-Dspring.profiles.active=prod", "/home/gradle/project/build/libs/kakao-1.0.jar"]

