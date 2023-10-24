FROM openjdk:8-jre-slim

#####download appserveragent from your controller and copy the file in to container path####
RUN mkdir -p /opt/appdynamics
COPY ./appserveragent/* /opt/appdynamics/


COPY ./myapp.jar /opt/myapp.jar
WORKDIR /opt/


ENTRYPOINT ["java","-javaagent:/appdynamics/javaagent.jar","-jar","myapp.jar"]
