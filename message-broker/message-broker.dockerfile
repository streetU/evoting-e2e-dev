ARG DOCKER_REGISTRY
FROM $DOCKER_REGISTRY/ev/rabbitmq:3.7

ENV BUILD_RESOURCES="./resources"
ENV INSTALL_DIR="/install"
ENV RABBIT_DEFINITIONS="rabbit.definitions.json"
ENV RABBIT_CONF="rabbitmq.conf"
ENV DEFINITIONS_DIR="/data"
ENV CA_CERT="ca_certificate.pem"
ENV SERVER_CERT="server_certificate.pem"
ENV PRIVATE_KEY="server_key.pem"
ENV KEY_PASSWORD="message-broker"

COPY $BUILD_RESOURCES/$RABBIT_DEFINITIONS $DEFINITIONS_DIR/
COPY $BUILD_RESOURCES/$CA_CERTFILE $BUILD_RESOURCES/$SERVER_CERTFILE $BUILD_RESOURCES/$PRIVATE_KEYFILE /etc/rabbitmq/
COPY $BUILD_RESOURCES/$RABBIT_CONF $INSTALL_DIR/

RUN sed -ie "s+@@rabbit.definitions@@+${DEFINITIONS_DIR}/${RABBIT_DEFINITIONS}+g" $INSTALL_DIR/$RABBIT_CONF
RUN sed -ie "s+@@cacertfile@@+${CA_CERT}+g" $INSTALL_DIR/$RABBIT_CONF
RUN sed -ie "s+@@certfile@@+${SERVER_CERT}+g" $INSTALL_DIR/$RABBIT_CONF
RUN sed -ie "s+@@keyfile@@+${PRIVATE_KEY}+g" $INSTALL_DIR/$RABBIT_CONF
RUN sed -ie "s+@@cert_password@@+${KEY_PASSWORD}+g" $INSTALL_DIR/$RABBIT_CONF

RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_federation_management

RUN mv $INSTALL_DIR/$RABBIT_CONF /etc/rabbitmq/
