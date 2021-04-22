FROM registry.access.redhat.com/ubi8/openjdk-11
USER root
VOLUME /downloads
ADD https://github.com/keycloak/keycloak/releases/download/12.0.4/keycloak.x-preview-12.0.4.tar.gz /downloads/
RUN mkdir -p /opt/keycloak 
RUN chmod 0777 /opt/keycloak
RUN ls -la /downloads
RUN tar -zxvf /downloads/keycloak.x-preview-12.0.4.tar.gz --directory /opt/keycloak
# RUN mkdir -p /etc/keycloak/
# RUN chmod 0777 /etc/keycloak/
# RUN cp /opt/keycloak/keycloak.x-12.0.4/conf/keycloak.properties /etc/keycloak/application.properties
RUN /opt/keycloak/keycloak.x-12.0.4/bin/kc.sh config --db=postgres --verbose --https-port=8443
# RUN /opt/keycloak/keycloak.x-12.0.4/bin/kc.sh config --db=postgres --verbose
EXPOSE 8443/tcp
USER 1000
ENTRYPOINT /opt/keycloak/keycloak.x-12.0.4/bin/kc.sh
