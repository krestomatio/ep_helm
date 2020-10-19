FROM etherpad/etherpad:1.8.6

USER root

# Install abiword and tidy
RUN apt-get -yqq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq install abiword tidy && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG ETHERPAD_PLUGINS=

USER etherpad

# install plugins
RUN for PLUGIN_NAME in ${ETHERPAD_PLUGINS}; do npm install "${PLUGIN_NAME}" || exit 1; done

# Fix permissions for root group
RUN chmod -R g=u .

EXPOSE 9001
