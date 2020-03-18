FROM alpine

ENV LOGGING_LEVEL=debug
ENV PACKAGE_VERSION=0.24.1
ENV PACKAGE_DIST=linux
ENV PACKAGE_ARCH=amd64
ENV DOWNLOAD_URL=https://releases.hashicorp.com/consul-template/${PACKAGE_VERSION}/consul-template_${PACKAGE_VERSION}_${PACKAGE_DIST}_${PACKAGE_ARCH}.tgz

RUN apk add tar && \
apk add wget && \
wget -q -O- $DOWNLOAD_URL | tar xvz && \
mv consul-template /usr/local/bin

CMD consul-template -consul-addr=$CONSUL_ADDR -vault-addr=$VAULT_ADDR -template=$TEMPLATE_FILEPATH:$CONFIG_OUTPUT_FILEPATH -vault-token=$VAULT_TOKEN -log-level=DEBUG $EXTRA_ARGS
