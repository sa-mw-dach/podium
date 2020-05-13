FROM node:current-alpine
MAINTAINER Sebastian Hetze <shetze@redhat.com>

RUN apk update; apk add bash git curl python2

WORKDIR /opt/

RUN git clone https://github.com/drichard/mindmaps.git

ENV PYTHON=/usr/bin/python2

WORKDIR mindmaps

RUN npm install && npm run build
RUN npm audit fix

RUN addgroup -g 1001 mindmap \
    && adduser -h /opt/mindmap -SD -G mindmap -u 1001 mindmap \
    && chown -R mindmap.mindmap /opt/mindmap

USER 1001
EXPOSE 8081
ENTRYPOINT ["/opt/mindmaps/node_modules/http-server/bin/http-server", "/opt/mindmaps/src", "-p 8081"]
