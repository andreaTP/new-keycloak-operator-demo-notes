FROM quay.io/keycloak/keycloak:18.0.0

RUN /opt/keycloak/bin/kc.sh build --db=postgres --health-enabled=true
