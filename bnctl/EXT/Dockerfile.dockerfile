FROM debian AS builder

ARG APPD_AGENT_VERSION=1.8-23.8.0.35032
ARG APPD_AGENT_ZIP=AppServerAgent-1.8-23.8.0.35032.zip
ARG APPD_AGENT_SHA256=bdb790454d44c21dab74bf400842739866c86faa9568bd95b35be1bc3b4c9c93

RUN apt-get update && apt-get install -y --no-install-recommends  unzip \
	&& rm -rf /var/lib/apt/lists/*

COPY ${APPD_AGENT_ZIP} /
RUN echo "${APPD_AGENT_SHA256} *AppServerAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq AppServerAgent-${APPD_AGENT_VERSION}.zip -d /tmp 
	
	
FROM openjdk:17-oracle

COPY --from=builder /tmp /opt/appdynamics
COPY ./myapp.jar /opt/myapp.jar
WORKDIR /opt/

ENV APPDYNAMICS_AGENT_APPLICATION_NAME=myapp-name 
ENV APPDYNAMICS_AGENT_TIER_NAME=myapp-tier 
ENV APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1 
ENV APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=0f9fc18a-02c3-484c-8864-f3a2609aedcc
ENV APPDYNAMICS_CONTROLLER_HOST_NAME=172.16.101.99 
ENV APPDYNAMICS_CONTROLLER_PORT=8022 
ENV APPDYNAMICS_CONTROLLER_SSL_ENABLED=false 
ENV APPDYNAMICS_JAVA_AGENT_REUSE_NODE_NAME=true 
ENV APPDYNAMICS_JAVA_AGENT_REUSE_NODE_NAME_PREFIX=myapp-node


ENTRYPOINT ["java","-javaagent:/opt/appdynamics/javaagent.jar","-jar","myapp.jar"]
