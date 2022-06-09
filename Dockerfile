# Build stage

FROM maven:3.6.0 AS BUILD_STAGE
WORKDIR /compiler
COPY . .
RUN ["mvn", "clean", "install", "-Dmaven.test.skip=true"]

# Run stage
FROM openjdk:11.0.6-jre-slim
WORKDIR /compiler

USER root

COPY --from=BUILD_STAGE /compiler/target/*.jar compiler.jar

RUN apt update && apt install -y docker.io
    
ADD executions/utility_java utility_java
ADD executions/utility_c utility_c
ADD executions/utility_cpp utility_cpp
ADD executions/utility_py utility_py
ADD executions/utility_go utility_go
ADD executions/utility_cs utility_cs
ADD executions/utility_kt utility_kt

ADD entrypoint.sh entrypoint.sh

RUN chmod a+x ./entrypoint.sh

EXPOSE 8082

ENTRYPOINT ["./entrypoint.sh"]


# Build image by typing the following command : "docker image build . -t onlinecompiler"
# Run the container by typing the following command : "docker container run -p 8080:8082 -v /var/run/docker.sock:/var/run/docker.sock -t onlinecompiler"
