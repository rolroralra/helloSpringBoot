FROM openjdk:8-jdk-alpine as builder
MAINTAINER rolroralra <rolroralra@naver.com>

ARG MAVEN_TARGET=target

COPY ${MAVEN_TARGET}/*.jar ./
RUN jar -xf *.jar


FROM openjdk:8-jdk-alpine

ARG SPRING_USER=spring
ARG PACKAGE_NAME=com.example.demo
ARG APPLICATION_NAME=DemoApplication

ENV PACKAGE_NAME ${PACKAGE_NAME}
ENV APPLICATION_NAME ${APPLICATION_NAME}

RUN addgroup -S ${SPRING_USER} && adduser -S ${SPRING_USER} -G ${SPRING_USER}
USER ${SPRING_USER}:${SPRING_USER}

COPY --from=builder BOOT-INF/lib /app/lib
COPY --from=builder META-INF /app/META-INF
COPY --from=builder BOOT-INF/classes /app

#ENTRYPOINT ["java","-cp","app:app/lib/*", "${PACKAGE_NAME}.${APPLICATION_NAME}"]
ENTRYPOINT java -cp app:app/lib/* ${PACKAGE_NAME}.${APPLICATION_NAME}